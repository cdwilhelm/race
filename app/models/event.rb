class Event < ActiveRecord::Base

  attr_accessor :tags#,:avg_score
  
  acts_as_mappable :default_units => :miles,
    :distance_field_name => :distance,
    :lat_column_name => :lat,
    :lng_column_name => :lng,
    :auto_geocode=>{:field=>:address, :error_message=>'Could not geocode address'}

  validates_presence_of :name,:event_type,:start_date,:city,:state
  validates_presence_of :end_date, :if=>:is_series
  validates_uniqueness_of :name,:scope=>[:start_date,:state]
  validates_format_of :website, :with => /^http\:\/\//,:message=>"must include http://"


  belongs_to :user
  has_many :event_comments,:dependent=>:delete_all
  # has_many :tags, :foreign_key => :object_id, :dependent=>:delete_all
  accepts_nested_attributes_for :event_comments, :allow_destroy => true
  # accepts_nested_attributes_for :tags, :allow_destroy => true

  before_save :clear_end_date
  
  
  named_scope :current, :conditions=>["start_date >= ?",Time.now]
  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def address
    "#{self.city}, #{self.state} #{self.zip_code}"
  end

  def geocode_address
    geo=Geokit::Geocoders::MultiGeocoder.geocode(address)
    errors.add(address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end


  def is_series
    self.series=='y'? true : false
  end

  def is_feature?
    self.feature=='y'? true : false

  end
  def clear_end_date
    self.end_date=nil unless is_series
  end
  
  def avg_rating
    avg = 0.0
    rating = Rating.find(:all,:conditions=>["object_id=? and object='Event'",id]).collect{|a| a.rating}
    if rating.size > 0
      avg = rating.sum / rating.size.to_f
      return avg
    end
    return avg.to_f
  end
  def self.avg_score(value)
    @avg_score
  end
  def self.avg_score
    @avg_score
  end
  
  def description
    "Find My Bike Race | #{name} a #{event_type} event #{venue_location.blank? ? "": "at "+venue_location.titleize}\
    in #{city.titleize}, #{state.upcase} on #{start_date.strftime("%b-%d-%Y")}."
  end
  
  def post_to_fb_page(fb_client)
    if fb_client
      begin 
      #find my bike race fb page id
      page = Mogli::Page.find('138642542858198') 
      
      #like the page if not already liked
      fb_client.post("#{page.id}/likes",nil,{}) unless page.can_post
      
      post = {:link=>"http://findmybikerace.com/events/#{to_param}",
        :message=>description,
        :icon=>'http://findmybikerace.com/images/crank-logo.png',
         :description=>notes,
      }
      # make a post
      fb_client.post("#{page.id}/feed",'Post',post)
      #fb_client.post("me/feed",'Post',post)
      rescue Exception => ex
        logger.error("#{Time.now} ERROR: Unable to post to facebook. \n#{ex.message} ")
      end

    end
  end
end