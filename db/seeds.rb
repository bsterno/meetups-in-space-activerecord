# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Example:
#
#   Person.create(first_name: 'Eric', last_name: 'Kelly')

if Sinatra::Base.development? || Sinatra::Base.test?
  User.create(provider: "test", uid: "test", username: "test", email: "test", avatar_url: "test")
  User.create(provider: 'tester', uid: 123, username: 'jrae', email: 'hithere@gmail.com', avatar_url: '/jessetar.jpg')
  User.create(provider: 'tester', uid: 234, username: 'drewman', email: 'hideehothere@gmail.com', avatar_url: '/drewtar.jpg')
  User.create(provider: 'tester', uid: 345, username: 'briman', email: 'heyboyhey@gmail.com', avatar_url: '/britar.jpg')


  Meetup.create(name: 'BRG', location: 'thoughbot hq', description: 'fun times')
  Meetup.create(name: 'LA fun time', location: 'mission control', description: 'launch votes & fun times')
  Meetup.create(name: 'TechJam', location: 'city hall plaza', description: 'not fun times')
  Meetup.create(name: 'Spacey Meetup', location: 'space', description: 'meetup in spaceeeee')


  Attendee.create(user_id: 2, meetup_id: 1)
  Attendee.create(user_id: 3, meetup_id: 1)
  Attendee.create(user_id: 1, meetup_id: 2)
  Attendee.create(user_id: 2, meetup_id: 2)
  Attendee.create(user_id: 3, meetup_id: 2)
  Attendee.create(user_id: 1, meetup_id: 3)
end
