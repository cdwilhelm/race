class HomeController < ApplicationController
  
  def index
    @events = Event.paginate(:all,:conditions=>["start_date > ?",Time.now ],
      :order=>"start_date,name",:page=>params[:page],:per_page=>"30")
     @events_by_month = @events.group_by { |e| e.start_date.strftime("%B %Y") }
  end
  def search
    @events = EventSearch.search(params).paginate(:page=>params[:page],:per_page=>"30")

  end
  
  def my_races
    @events = Event.paginate_by_user_id(current_user.id,
      :order=>"start_date, name, state",:page=>params[:page],:per_page=>"30")#.paginate(:page=>params[:page],:per_page=>"30")
  end

  def about
    @page_title="About"
  end

  def contact_us
     @page_title="Contact Us"
  end

  def help
     @page_title="Help"
  end

end
