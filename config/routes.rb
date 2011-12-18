ActionController::Routing::Routes.draw do |map|
  map.resources :event_comments

  map.resources :users, :collection => {:link_user_accounts => :get}
  map.resources :events
  #map.resources :admin
  map.resource :rating
  map.resource :tags

  map.namespace :event do |event|
    event.resources :event_comments
  end

  map.namespace :admin do |admin|
    admin.resources :users
    admin.resources :events
  end


  map.forgot    '/forgot',                    :controller => 'users',     :action => 'forgot'
  map.reset     'reset/:reset_code',          :controller => 'users',     :action => 'reset'
  map.activate     'activate/:activation_code',          :controller => 'users',     :action => 'activate'
  map.logout "logout"  , :controller=>"users", :action=>"logout"
  map.logout "logout_fb"  , :controller=>"users", :action=>"logout_fb"
  map.login "login", :controller=>"users" ,:action=>"login"
  map.admin "admin",:controller=>"admin",:action=>"index"
  map.my_page "my_page" ,:controller=>:home,:action=>:my_page
  map.connect 'sitemap.xml', :controller => "sitemap", :action => "sitemap"
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "home"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
