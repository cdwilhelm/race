class SitemapController < ApplicationController
  def sitemap
    @events = Event.find(:all, :conditions=>["start_date >= ?",Time.now - 11.months], :order => "updated_at DESC")

    headers["Content-Type"] = "text/xml"
    # set last modified header to the date of the latest entry.
    headers["Last-Modified"] = @events[0].updated_at.httpdate || Time.now.httpdate
    render :layout=>false
  end

end
