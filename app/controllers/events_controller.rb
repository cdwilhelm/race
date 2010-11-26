class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  before_filter :authorize, :except=>:show
  def index

    redirect_to root_path
  end



  # GET /events/1
  # GET /events/1.xml
  def show

    @event = Event.find(params[:id])
    @page_title="#{@event.name} #{@event.city} #{@event.state} #{@event.start_date}"
    @page_desc=@event.notes
    @page_keywords="#{@event.name},#{@event.venue_location} #{@event.city}, #{@event.state}, #{@event.event_type}"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @page_title="Add Race"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    @page_title="Edit Race"
    @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30")

  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.user = current_user
 
    respond_to do |format|
      if @event.save
        #twitter(@event)
        @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30")
        flash.now[:notice] = 'Event was successfully created.'
        format.html { render :action=>:edit}
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30")
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30")
        flash.now[:notice] = 'Event was successfully updated.'
        format.html { render :action=>:edit }
        format.xml  { head :ok }
      else
        @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30")
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  private

  def twitter(event)
    if APP_CONFIG['perform_twitter']
      oauth = Twitter::OAuth.new('consumer token', 'consumer secret')
      oauth.authorize_from_access('access token', 'access secret')

      client = Twitter::Base.new(oauth)
      client.friends_timeline.each  { |tweet| puts tweet.inspect }
      client.user_timeline.each     { |tweet| puts tweet.inspect }
      client.replies.each           { |tweet| puts tweet.inspect }

      client.update('Heeeyyyyoooo from Twitter Gem!')
    end

  end
end
