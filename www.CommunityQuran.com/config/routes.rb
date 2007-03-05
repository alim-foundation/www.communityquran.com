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
  map.connect '', :controller => "quran"

  # Straight 'http://my.app/quran/' displays the index
  map.connect "quran/", :controller => "quran",  :action => "index"

  # Straight 'http://my.app/quran/surahs' displays the first available sura introduction
  map.connect "quran/surahs", :controller => "quran",  :action => "surahs"

  # Return surah introduction for a specific quran and surah number
  map.connect "quran/surahs/:quran_code/:surah_num", :controller => "quran", :action => "surahs" 

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
