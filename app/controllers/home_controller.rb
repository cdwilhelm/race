class HomeController < ApplicationController
  
  def index
    @events = Event.paginate(:all,:conditions=>["start_date > ?",Time.now ],
      :order=>"start_date,name",:page=>params[:page],:per_page=>"30")
    @events_by_month = @events.group_by { |e| e.start_date.strftime("%B %Y") }
  end
  def search
    @events = EventSearch.search(params).paginate(:page=>params[:page],:per_page=>"30")
    @events_by_month = @events.group_by { |e| e.start_date.strftime("%B %Y") }
  end
  
  def my_page
    @events = Event.current.paginate_by_user_id(current_user.id,
      :order=>"start_date, name, state",:page=>params[:page],:per_page=>"30")#.paginate(:page=>params[:page],:per_page=>"30")
    @user = User.find(current_user_id)
    
  end

  def contactus_sendmail
    message = params[:message]
	  email = message["email"]
	  subject = message["subject"]
    category = message["category"]
	  body = message["body"]


    Notifier.deliver_contactus(email,subject,body,category)
    flash.now[:notice] = "Thank you! Your message has been sent."
    render :controller=>:home, :action=>:contact_us

  end
  
  def privacy
    @page_title="Privacy"
  end
  
    def tos
    @page_title="Terms of service"
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

  def advertise
    @page_title="Advertise On Our Site"
  end

end
