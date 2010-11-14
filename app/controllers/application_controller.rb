# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
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

end
def state_list
  [
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
def current_user_id
  session[:user_id]
end
#hide_action :current_user_id

def current_user_logged_in?
  ! current_user.nil?
end
#hide_action :current_user_logged_in?
#helper_method :current_user_logged_in?

def is_admin
  if current_user_logged_in?
    current_user.role=='admin'
  else
    false
  end

end

private
# Retrieves the user for the current session.
def current_user
  @current_user ||= current_user_id ? User.find(current_user_id) : User.anonymous
end
#helper_method :current_user

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
  unless User.find_by_id(session[:user_id])
    session[:original_uri] = request.request_uri
    flash[:notice] = "Please log in"
    redirect_to(:controller => "/users" , :action => "login" )
  end

end

def admin
  unless User.find_by_id(session[:user_id],:conditions=>"role='admin'")
    session[:original_uri] = request.request_uri
    flash[:notice] = "Your account is not authorized to access this page."
    redirect_to(:controller => "/users" , :action => "login" )
  end
end