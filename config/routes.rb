ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.resources :views, :collection => {:reorder => :any, :add_column => :any, :remove_column => :any, :search => :any,
                                        :friend => :any, :import => :any}
  map.directory '', :controller => "directory", :action => "index"
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
end
