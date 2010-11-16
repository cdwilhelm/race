class Admin::EventsController < ApplicationController

  before_filter :authorize
  ssl_exceptions
  def index
    @events = Event.all
  end

  def search
    @events = EventSearch.search(params)#.paginate(:page=>params[:page],:per_page="30")
  end

  def edit
    @event = Event.find(params[:id])
  end


  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

end
