class AddEventMeasurement < ActiveRecord::Migration
  def self.up
    add_column :events,:distance,:string
    add_column :events,:measurement,:string
  end

  def self.down
    remove_column :events,:distance
    remove_column :events,:measurement
  end
end
