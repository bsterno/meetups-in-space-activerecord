class Meetup < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true
  validates :description, presence: true

  has_many :attendees
  has_many :users, through: :attendees
end
