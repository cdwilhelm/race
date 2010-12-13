class User < ActiveRecord::Base
  validates_presence_of :first_name,:last_name,:email,:nickname
  validates_uniqueness_of :email
  attr_accessor :password_confirmation,:email_confirmation
  validates_confirmation_of :password,:email
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'is not formated correctly.  Use you@example.com',
    :if=> :email
  validates_format_of [:phone], :allow_nil=>true,:allow_blank=>true, :with=>/^\d\d\d-\d\d\d-\d\d\d\d$/,
    :message =>"must be of the format: ###-###-####"

  has_many :events
  has_many :event_comments
  
  def validate
    errors.add_to_base("Missing password" ) if hashed_password.blank?
  end


  def self.authenticate(name, password)
    user = self.find_by_email(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  # 'password' is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  private
  def self.encrypted_password(password, salt)
    require 'digest/sha1'
    string_to_hash = password + "wibble" + salt # 'wibble' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def anonymous?
    self.name.nil?
  end

  def self.anonymous
    @anonymous ||= User.find :first, :conditions => "users.first_name is null"
  end

  def logged_in?
    self.name
  end
end
