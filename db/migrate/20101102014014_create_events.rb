class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name, :null=> false
      t.string :website
      t.string :promoter
      t.date   :start_date ,:null=>false
      t.date   :end_date
      t.string :venue_location
      t.string :city,:null=>false
      t.string :zip_code
      t.string :state,:null=>false
      t.string :series,:default=>''
      t.string :event_type,:null=>false
      t.string :featured, :default=>'n'
      t.string :logo_path
      t.string :user_id,:null=>false
      t.float  :lat
      t.float  :lng
      t.text   :notes
      t.timestamps
    end

    add_index :events,:name
    add_index :events,:state
    add_index :events,:event_type
    add_index :events,:user_id
    add_index  :events, [:lat, :lng]
  end

  def self.down
    remove_index :events, :name
    remove_index :events,:state
    remove_index :events,:event_type
    remove_index :events,:user_id
    remove_index  :events, [:lat, :lng]
    drop_table :events
  end
  
end
