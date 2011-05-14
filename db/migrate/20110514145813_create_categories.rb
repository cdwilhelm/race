require "migration_helpers"
class CreateCategories < ActiveRecord::Migration
  extend MigrationHelpers

  def self.up
    create_table :categories do |t|
      t.integer :registration_id
      t.string :name
      t.decimal :fee,:precision => 5, :scale => 2, :default => 0.0
      t.integer :field_limit

      t.timestamps
    end
    add_foreign_key(:categories, :registration_id, :registrations)
  end

  def self.down
     remove_foreign_key(:categories, :registration_id)
    drop_table :categories
  end
end
