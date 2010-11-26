module EventsHelper

  require 'cgi'
  def marker(event)
    "<div class=\"address\">#{CGI.escapeHTML(event.name.upcase)}<br/>#{CGI.escapeHTML(event.city.capitalize)},#{CGI.escapeHTML(event.state.upcase)} #{event.zip_code} </div>"
  end
end
