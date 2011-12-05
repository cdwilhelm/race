class AddRatings < ActiveRecord::Migration
  def self.up
      create_table :ratings do |t|
      t.string :object_id, :null=> false
      t.string :object, :null=>false
      t.string :user_id, :null=>false
      t.integer :rating, :null=>false
      t.timestamps
    end
    add_index :ratings,[:rating,:object_id,:object],:unique>true

  end

  def self.down
    remove_index :ratings, [:object_id,:object]
    drop_table :ratings
  end
end
