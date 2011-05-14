class UsersDetail < ActiveRecord::Migration
  def self.up
    add_column(:users,:birth_date,:date)
    add_column(:users,:emergency_contact,:string)
    add_column(:users,:emergency_contact_phone,:string)
    add_column(:users,:license,:string)
    add_column(:users,:club,:string)
    rename_column(:users,:address_1,:address_2)
    rename_column(:users,:address,:address_1)


  end

  def self.down
    remove_column(:users,:birth_date,:date)
    remove_column(:users,:emergency_contact,:string)
    remove_column(:users,:emergency_contact_phone,:string)
    remove_column(:users,:license,:string)
    remove_column(:users,:club,:string)
    rename_column(:users,:address_2,:address_1)
    rename_column(:users,:address_1,:address)
  end
end
