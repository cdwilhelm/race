require "migration_helpers"
class ForgienKeys < ActiveRecord::Migration
  extend MigrationHelpers
  def self.up
    change_column(:events,:user_id, :integer,:default=>0)
    add_foreign_key(:events, :user_id, :users)
    add_foreign_key(:event_comments, :user_id, :users)
    add_foreign_key(:event_comments, :event_id, :events)
    
  end

  def self.down
    remove_foreign_key(:events, :user_id)
    remove_foreign_key(:event_comments, :user_id)
    remove_foreign_key(:event_comments, :event_id)
    change_column(:events,:user_id, :string)

  end
end
