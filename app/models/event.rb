class Event < ActiveRecord::Base
  validates_presence_of :name,:event_type,:start_date,:location,:state
 # validates_presence_of :end_date, :if=>:featured
  validates_uniqueness_of :name,:scope=>[:start_date,:state]

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  composed_of :start_date,
    :class_name => 'Date',
    :mapping => %w(start_date to_s),
    :constructor => Proc.new { |start_date| (start_date && start_date.to_date) || Date.today },
    :converter => Proc.new { |value| value.to_s.to_date }

  composed_of :end_date,
    :class_name => 'Date',
    :mapping => %w(end_date to_s),
    :constructor => Proc.new { |end_date| (end_date && end_date.to_date) || Date.today },
    :converter => Proc.new { |value| value.to_s.to_date }
end
