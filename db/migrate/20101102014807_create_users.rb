class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email , :null=>false
      t.string :first_name,:null=>false
      t.string :last_name, :null=>false
      t.string :hashed_password
      t.string :salt
      t.string :role,:default=>'user'
      t.string :address
      t.string :address_1
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country, :default=>'USA'
      t.string :phone

      t.timestamps
    end
    add_index :users,:email
  end

  def self.down
    remove_index :users,:email
    drop_table :users
  end
end
