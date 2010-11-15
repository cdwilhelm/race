class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name, :null=> false
      t.string :website
      t.string :promoter
      t.date :start_date ,:null=>false
      t.string :end_date
      t.string :location
      t.string :state,:null=>false
      t.boolean :series,:default=>false
      t.string :event_type,:null=>false
      t.boolean :featured, :default=>false
      t.string :logo_path
      t.string :user_id,:null=>false
      t.timestamps
    end

    add_index :events,:name
    add_index :events,:state
    add_index :events,:event_type
    add_index :events,:user_id
  end

  def self.down
    remove_index :events, :name
    remove_index :events,:state
    remove_index :events,:event_type
    remove_index :events,:user_id
    drop_table :events
  end
  
end
