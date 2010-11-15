class HomeController < ApplicationController
  def index
    @events = Event.all(:conditions=>"curdate()  >= start_date",:order=>"start_date,name")
  end
  def search
  @events = EventSearch.search(params)#.paginate(:page=>params[:page],:per_page="30")
  end
  def about
  end

  def contact_us
  end

  def help
  end

end
