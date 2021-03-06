class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.string :name, unique: true, null: false
      t.string :location, null: false
      t.text :description, null: false
    end
  end
end
