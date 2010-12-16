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
    #@event.event_comments.build
    @comment = EventComment.new

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
    @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30",:order=>"start_date,name")

  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])
    @event.user = current_user

    @event.save
    respond_to do |format|
      if @event.save
        twitter(@event)
        @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30",:order=>"start_date,name")
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

  def create_comment
    @event = Event.find(params[:event_comment][:event_id])

    if current_user_logged_in? and !params[:event_comment][:comment].blank?
      @event_comment = EventComment.new(params[:event_comment])
      @event_comment.user=current_user
      @event_comment.save
    end
    render :update do |page|
      page.replace_html 'comments',:partial=>'comments' 
      #page.assign 'event_comment_comment', ''
      #page.call "$('event_comment_comment').value", ""
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    #@event.event_comments.build(:user_id=>current_user_id})

    respond_to do |format|
      if @event.update_attributes(params[:event])
        @events = Event.paginate_by_user_id(current_user.id,:page=>params[:page],:per_page=>"30",:order=>"start_date,name")
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
      oauth = Twitter::OAuth.new('RAsOrkbfuqehJDpHZBwChQ', 'suOP6dyR6wgj26XENzOZZbGeUeD3ynukO9Pwbg3Ng')
      oauth.authorize_from_access('https://api.twitter.com/oauth/access_token', 'RAsOrkbfuqehJDpHZBwChQ')

      client = Twitter::Base.new(oauth)
#      client.friends_timeline.each  { |tweet| puts tweet.inspect }
#      client.user_timeline.each     { |tweet| puts tweet.inspect }
#      client.replies.each           { |tweet| puts tweet.inspect }

      client.update("Posted: #{event.name} on #{event.state_date}  via http://findmyrace.com/#{event.id}")
    end

  end
end
