class RatingsController < ApplicationController
  
 
  def rate

    if current_user_logged_in?
      user_rating = Rating.find_by_user_id_and_object_id_and_object(current_user_id, params[:id], 'Event')
   
      if user_rating and user_rating.rating!= params[:score]
        user_rating.rating=params[:score]
        user_rating.save
      else
        Rating.create({:rating=>params[:score],
            :user_id=>current_user_id,
            :object_id=>params[:id],
            :object=>'Event'
          } )
      end
    

      render :nothing => true
    else
      render :update do |page|
        page.call "alert","Please login to rate an event." 
      end
    end
  end
  
  private 

end
