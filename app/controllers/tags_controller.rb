class TagsController < ApplicationController


  
  
  def get_tags
    name = params[:name] #.split(",").last.strip
    @tags = Tag.find(:all,:conditions=>["name like ?","%#{name}%"],:limit=>10)
    
     render :inline => "<%= auto_complete_result @tags, '#{:name}' %>"
  end
end
