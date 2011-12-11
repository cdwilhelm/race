# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include SslRequirement
  #only have ssl in prod
  def ssl_required?
    return false if local_request? || RAILS_ENV == 'test' || RAILS_ENV == 'development'
    super
  end
  #   Scrub sensitive parameters from your log
  filter_parameter_logging :password
  protect_from_forgery
  
  def event_type_list
    [["Cross Country"],["Marathon"],["Ultra Endurance"],["Short Track"],["Stage Race"],["Cyclocross"],["Road"],
      ["Downhill"],["SuperD"],["Time Trial"]]
  end
  helper_method :event_type_list
  
  def state_list
    [ ["Select State",""],
      ['Alabama', 'AL'],
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'],
      ['California', 'CA'],
      ['Colorado', 'CO'],
      ['Connecticut', 'CT'],
      ['Delaware', 'DE'],
      ['District Of Columbia', 'DC'],
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'],
      ['Idaho', 'ID'],
      ['Illinois', 'IL'],
      ['Indiana', 'IN'],
      ['Iowa', 'IA'],
      ['Kansas', 'KS'],
      ['Kentucky', 'KY'],
      ['Louisiana', 'LA'],
      ['Maine', 'ME'],
      ['Maryland', 'MD'],
      ['Massachusetts', 'MA'],
      ['Michigan', 'MI'],
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'],
      ['Missouri', 'MO'],
      ['Montana', 'MT'],
      ['Nebraska', 'NE'],
      ['Nevada', 'NV'],
      ['New Hampshire', 'NH'],
      ['New Jersey', 'NJ'],
      ['New Mexico', 'NM'],
      ['New York', 'NY'],
      ['North Carolina', 'NC'],
      ['North Dakota', 'ND'],
      ['Ohio', 'OH'],
      ['Oklahoma', 'OK'],
      ['Oregon', 'OR'],
      ['Pennsylvania', 'PA'],
      ['Rhode Island', 'RI'],
      ['South Carolina', 'SC'],
      ['South Dakota', 'SD'],
      ['Tennessee', 'TN'],
      ['Texas', 'TX'],
      ['Utah', 'UT'],
      ['Vermont', 'VT'],
      ['Virginia', 'VA'],
      ['Washington', 'WA'],
      ['West Virginia', 'WV'],
      ['Wisconsin', 'WI'],
      ['Wyoming', 'WY']]
  end
  helper_method :state_list

  def current_user_id
    current_user.id
  end
  helper_method :current_user_id

  def current_user_logged_in?
    ! current_user.nil?
  end
  helper_method :current_user_logged_in?

  def is_admin?
    if current_user_logged_in?
      current_user.role=='admin'
    else
      false
    end

  end
  helper_method :is_admin?

  def is_promoter?
    if current_user_logged_in?
      current_user.role=='promoter'
    else
      false
    end
  end
  
  helper_method :current_user_logged_in?
  # Retrieves the user for the current session.
  def current_user
    #@current_user ||= current_user_id ? User.find(current_user_id) : User.anonymous
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    elsif current_facebook_user and @current_user.nil?
      @current_user = User.find_by_facebook_id(current_facebook_user.id)
    end
    return @current_user
  end
  helper_method :current_user
  
  private


  def current_user_id=(id)
    session[:user_id] = id
    # Invalidate cached value
    @current_user = nil
  end

  def current_user=(user)
    self.current_user_id = user.id if user
    @current_user = user
  end

  def authorize
    unless current_user
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in"
      #render :update do |page|
      # page.alert("Your session has expired.  Please log in to add a comment!")
      # page.redirect_to(request.request_uri) if current_user_logged_in?
      # page.redirect_to(login_path(:securt=>true)) unless current_user_logged_in?
      #
      #end
      redirect_to(login_path(:session=>true))
    end
  end



  def admin
    unless User.find_by_id(session[:user_id],:conditions=>"role='admin'")
      session[:original_uri] = request.request_uri
      flash[:notice] = "Your account is not authorized to access this page."
      redirect_to(:controller => "/users" , :action => "login" )
    end


  end
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end


end