module HomeHelper

  def end_date
    Time.now + 3.month
  end
  
  def search_sort_link(name,sort)
    order="DESC"
    unless params[:search].nil?
      case params[:search][:order]
      when 'DESC'
        order='ASC'
      when 'ASC'
        order='DESC'
      else
        order='DESC'
      end
    end
    link_to_remote name, :update=>'result', :url=>{:action=>'search', :params=>session[:search], "search[sort]"=>sort, "search[order]"=>order} 
  end
  
end
