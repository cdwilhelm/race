class AddNicknameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:nickname,:string,{:limit=>10}
  end

  def self.down
    remove_column :users,:nickname
  end
end
