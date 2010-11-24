class HomeController < ApplicationController
  
  def index
    @events = Event.paginate(:all,:conditions=>["start_date > ?",Time.now ],
      :order=>"start_date,name",:page=>params[:page],:per_page=>"30")
  end
  def search
    @events = EventSearch.search(params).paginate(:all,:page=>params[:page],:per_page=>"30")

  end

  def about
  end

  def contact_us
  end

  def help
  end

end
