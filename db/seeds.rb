# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create([
    {
      :first_name => "Curt",
      :last_name => "Wilhelm",
      :email => "curt_wilhelm@yahoo.com",
      :salt => "NaC1",
      :hashed_password => User.encrypted_password('FooBar', 'NaC1'),
      :role=>"admin"
    },
    {   :first_name => "Jonathan",
      :last_name => "Davis",
      :email => "jonathan@hpdlighting.com",
      :salt => "NaC1",
      :hashed_password => User.encrypted_password('FooBar', 'NaC1'),
      :role=>"admin"
    }
  ])