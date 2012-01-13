class User < ActiveRecord::Base

  #  acts_as_mappable :default_units => :miles,
  #    :distance_field_name => :distance,
  #    :lat_column_name => :lat,
  #    :lng_column_name => :lng,
  #    :auto_geocode=>{:field=>:address, :error_message=>'Could not geocode address'}

  validates_presence_of :first_name,:last_name,:email
  validates_presence_of :nickname, :unless=>:reset_password?
  validates_uniqueness_of :email,:nickname,:unless=>:reset_password?
  attr_accessor :password_confirmation,:email_confirmation
  validates_confirmation_of :password,:email
  validates_numericality_of  :zipcode,:allow_nil=>true, :allow_blank=>true
  validates_length_of :password, :within=>6...12, :unless=>Proc.new{|p| p.password.blank?  or p.facebook_id.blank? }
  validates_format_of :email,
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
    :message => 'is not formated correctly.  Use you@example.com',
    :if=> :email
  validates_format_of [:phone], :allow_nil=>true,:allow_blank=>true, :with=>/^\d\d\d-\d\d\d-\d\d\d\d$/,
    :message =>"must be of the format: ###-###-####"

  has_many :events
  has_many :event_comments

  after_save :reset_notification
  #after_save :activation_notification
  after_create :signup_notification  

  attr_accessor :reset_password

  def validate
    errors.add_to_base("Missing password" ) if hashed_password.blank? and ! facebook_id
  end

  #  def address
  #    "#{self.city}, #{self.state} #{self.zipcode}"
  #  end

  def self.authenticate(name, password)
    user = self.find_by_email(name,:conditions=>"activation_code is null")
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

  def create_reset_code
    @reset = true
    self.attributes = {:reset_code => Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )}
    save(false)
  end

  def create_activation_code
    @activated = true
    self.attributes = {:activation_code => Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )}
    save(false)
  end

  def recently_reset?
    @reset
  end

  def recently_activated?
    @activated
  end

  def delete_reset_code
    self.attributes = {:reset_code => nil}
    save(false)
  end
  def delete_activation_code
    self.attributes = {:activation_code => nil}
    save(false)
  end
  def reset_password?
    self.reset_password==true
  end
  
  def facebook_user?
    return !facebook_id.nil? && facebook_id.to_i > 0
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

  def reset_notification
    UserNotifier.deliver_reset_notification(self) if self.recently_reset?
  end
  def activation_notification
    UserNotifier.deliver_activation(self) if self.recently_activated?
  end
  def signup_notification
    UserNotifier.deliver_signup_notification(self) unless facebook_id.blank?
  end
 
  #find the user in the database, first by the facebook user id and if that fails through the email hash
  def self.find_by_fb_user(fb_user)
    User.find_by_facebook_id(fb_user.id) || User.find_by_email_hash(fb_user.email_hashes)
  end
 
  #Take the data returned from facebook and create a new user from it.
  #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
  #If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
  def self.create_from_fb_connect(fb_user)
    
    fb_user.fetch
    new_facebooker = User.new( :password => "", :email => fb_user.email, :first_name=>fb_user.first_name, :last_name=>fb_user.last_name)
    new_facebooker.facebook_id = fb_user.id
 
    #We need to save without validations
    new_facebooker.save(false)
    #new_facebooker.register_user_to_fb
  end
 
  #We are going to connect this user object with a facebook id. But only ever one account.
  def link_fb_connect(fb_id)
    unless fb_id.nil?
      #check for existing account
      existing_fb_user = User.find_by_facebook_id(fb_id)
 
      #unlink the existing account
      unless existing_fb_user.nil?
        existing_fb_user.facebook_id = nil
        existing_fb_user.save(false)
      end
 
      #link the new one
      self.facebook_id = fb_id
      save(false)
    end
  end
  
  def facebook_user?
    return !facebook_id.nil? && facebook_id.to_i > 0
  end
 

end
