class Event < ActiveRecord::Base

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
end
