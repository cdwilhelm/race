class EventSearch



  def self.search(params)
    @name=params['name']
    @start_date=params['start_date']
    @end_date=params['end_date']
    @event_type=params['event_type']
    @state=params['state']
    @sort=params['sort']
    @order=params['order']

    find_events
  end


  private

  def self.find_events
    Event.find(:all,
      :select=>"events.id,events.name, events.start_date, events.state, events.event_type, avg(ratings.rating) as avg_score",
      :joins=>"left join ratings on ratings.object_id = events.id and ratings.object='Event'",
      :group=>'events.name, events.start_date, events.state, events.event_type',
      :conditions => conditions ,
      :order=>"#{order}")
  end

  def self.order
    if @sort
      "#{@sort+" "+@order}"
    else
      "start_date, name"
    end
  end

  def self.name_conditions
    ["name LIKE ?", "%#{@name}%"] unless @name.blank?
  end

  def self.event_type_conditions
    ["event_type=?", @event_type] unless @event_type.blank?
  end
  def self.date_conditions
    ["start_date between ? and ?", @start_date,@end_date] unless @start_date.blank?
  end

  def self.state_conditions
    ["state = ?", "#{@state}"] unless @state.blank?
  end

  def self.conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def self.conditions_clauses
    conditions_parts.map { |condition|  condition.first }
  end

  def self.conditions_options

    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def self.conditions_parts
    self.methods.grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
