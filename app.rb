require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'pry'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    user_id = session[:user_id]
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)
  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
  end
end

get '/' do
  @title = "Hello World"
  erb :index
end

get '/view_all' do
  authenticate!
  meetups = Meetup.all
  erb :show, locals: { meetups: meetups }
end

post '/view_all' do
  name = params[:name]
  location = params[:location]
  description = params[:description]

  Meetup.create!(name: name, location: location, description: description)

  redirect "/view_all"
end


get '/meetups/:meetup_id' do
  meetup_id = params["meetup_id"]
  meetup = Meetup.where(id: meetup_id)[0]

  attendees = Attendee.where(meetup_id: meetup_id)
  erb :meetups, locals: { meetup_id: meetup_id, meetup: meetup, user_id: session[:user_id], attendees: attendees }
end

post '/meetups/:meetup_id' do
  meetup_id = params["meetup_id"]
  meetup = Meetup.where(id: meetup_id)[0]
  attendees = Attendee.where(meetup_id: meetup_id)

  if Attendee.where(user_id: session[:user_id], meetup_id: meetup_id).empty?
    Attendee.create!(user_id: session[:user_id], meetup_id: meetup_id )
    flash[:notice] = "You're now signed up for the event!"
  else
    flash[:notice] = "You've already signed up for this event!"
  end

  redirect "/meetups/#{meetup_id}"
  erb :meetups, locals: { meetup_id: meetup_id, meetup: meetup, attendees: attendees }
end



post '/meetups/:meetup_id/remove' do
  meetup_id = params["meetup_id"]

  if Attendee.where(user_id: session[:user_id], meetup_id: meetup_id).present?
    Attendee.destroy_all(user_id: session[:user_id], meetup_id: meetup_id )
    flash[:notice] = "You are no longer signed up for this event!"
  else
    flash[:notice] = "You aren't attending this event"
  end

  redirect "/meetups/#{meetup_id}"
end


get '/auth/github/callback' do
  auth = env['omniauth.auth']

  user = User.find_or_create_from_omniauth(auth)
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/view_all'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
