class AddLocationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:opt_in, :string ,{:limit=>1,:default=>'y'}
    add_column :users,:lat,:float
    add_column :users,:lng,:float
    add_index  :users, [:lat, :lng]
  end

  def self.down
    remove_column :users,:opt_in
    remove_column :users,:lat
    remove_column :users,:lng
    remove_index  :events, [:lat, :lng]
  end
end
