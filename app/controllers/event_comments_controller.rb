class EventCommentsController < ApplicationController
  # GET /event_comments
  # GET /event_comments.xml
  def index
    @event_comments = EventComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event_comments }
    end
  end

  # GET /event_comments/1
  # GET /event_comments/1.xml
  def show
    @event_comment = EventComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event_comment }
    end
  end

  # GET /event_comments/new
  # GET /event_comments/new.xml
  def new
    @event_comment = EventComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_comment }
    end
  end

  # GET /event_comments/1/edit
  def edit
    @event_comment = EventComment.find(params[:id])
  end

  # POST /event_comments
  # POST /event_comments.xml
  def create
    @event_comment = EventComment.new(params[:event_comment])

    @event_comment.user=current_user
    @event_comment.save
    #    respond_to do |format|
    #      if @event_comment.save
    #        flash[:notice] = 'EventComment was successfully created.'
    #        format.html { redirect_to(@event_comment) }
    #        format.xml  { render :xml => @event_comment, :status => :created, :location => @event_comment }
    #        format.js {}
    #      else
    #        format.html { render :action => "new" }
    #        format.xml  { render :xml => @event_comment.errors, :status => :unprocessable_entity }
    #      end
    #    end
  end

  # PUT /event_comments/1
  # PUT /event_comments/1.xml
  def update
    @event_comment = EventComment.find(params[:id])

    respond_to do |format|
      if @event_comment.update_attributes(params[:event_comment])
        flash[:notice] = 'EventComment was successfully updated.'
        format.html { redirect_to(@event_comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_comments/1
  # DELETE /event_comments/1.xml
  def destroy
    @event_comment = EventComment.find(params[:id])
    @event_comment.destroy

    respond_to do |format|
      format.html { redirect_to(event_comments_url) }
      format.xml  { head :ok }
    end
  end
end
