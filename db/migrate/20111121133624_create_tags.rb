class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :object_id
      t.string :object
      t.string :name

      t.timestamps
    end
    add_index :tags,:name
    add_index :tags,[:name,:object_id,:object], :unique=>true
    add_index :tags,:object
  end

  def self.down
    remove_index :tags,:name
    remove_index :tags,[:name, :object_id,:object]
    remove_index :tags,:object
    drop_table :tags
  end
end
