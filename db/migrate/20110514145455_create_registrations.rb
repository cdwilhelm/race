require "migration_helpers"
class CreateRegistrations < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    create_table :registrations do |t|
      t.integer :event_id
      t.integer :user_id
      t.string :address
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :phone
      t.string :email
      t.string :emergency_contact
      t.string :emergency_contact_phone
      t.string :club
      t.date :birth_date
      t.string :license
      t.decimal :fee ,:precision => 5, :scale => 2, :default => 0.0

      t.timestamps
    end
    add_foreign_key(:registrations, :event_id, :events)

  end

  def self.down
    remove_foreign_key(:registrations,:event_id)
    drop_table :registrations

  end
end
