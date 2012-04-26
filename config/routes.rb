Sitrack::Application.routes.draw do |map|
  map.resources :views, :collection => {:reorder => :any, :add_column => :any, :remove_column => :any, :search => :any,
                                        :friend => :any, :import => :any, :borrow => :any}
  map.directory '', :controller => "directory", :action => "index"
  
  map.options 'js/options.js', :controller => 'js', :action => 'options', :format => 'js'
#  map.connect 'directory', :controller => "directory", :action => "index"
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  map.connect 'profile/:id', :controller => 'profile',
                             :action => 'index',
                             :requirements => {:id => /\d+/}
  map.connect 'logout', :controller => 'application', :action => 'logout'

  map.connect 'up_monitor', :controller => "application", :action => "up_monitor"

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id'
  
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
