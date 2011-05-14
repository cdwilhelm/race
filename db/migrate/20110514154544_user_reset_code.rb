class UserResetCode < ActiveRecord::Migration
  def self.up
    add_column(:users,:reset_code,:string,:limit=>40)
    add_column(:users,:activation_code,:string,:limit=>40)
  end

  def self.down
    remove_column(:users,:reset_code)
    remove_column(:users,:activation_code)
  end
end
