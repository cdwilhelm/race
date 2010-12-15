class CreateEventComments < ActiveRecord::Migration
  def self.up
    create_table :event_comments do |t|
      t.integer :event_id
      t.integer :user_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :event_comments
  end
end
