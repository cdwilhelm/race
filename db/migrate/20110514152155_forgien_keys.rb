require "migration_helpers"
class ForgienKeys < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    change_column(:events,:user_id, :integer)
    add_foreign_key(:events, :user_id, :users)
     add_foreign_key(:event_comments, :user_id, :users)
         add_foreign_key(:event_comments, :event_id, :events)
    
  end

  def self.down
    change_column(:events,:user_id, :string)
    remove_foreign_key(:events, :user_id) 
  end
end
