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
    remove_column(:users,:birth_date)
    remove_column(:users,:emergency_contact)
    remove_column(:users,:emergency_contact_phone)
    remove_column(:users,:license)
    remove_column(:users,:club)
    rename_column(:users,:address_1,:address)
    rename_column(:users,:address_2,:address_1)

  end
end
