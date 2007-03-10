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

  map.connect "quran/", :controller => "quran",  :action => "index"

  map.connect "quran/search/:expression", :controller => "quran",  :action => "search"

  map.connect "quran/subjects", :controller => "quran",  :action => "subjects", :quran_code => 'QSB', :letter => 'A'
  map.connect "quran/subjects/:letter", :controller => "quran",  :action => "subjects", :quran_code => 'QSB'
  map.connect "quran/subjects/:quran_code/:letter", :controller => "quran",  :action => "subjects"
  map.connect "quran/subjects/:quran_code/:letter/:subject_id", :controller => "quran",  :action => "subjects"

  map.connect "quran/arabic", :controller => "quran",  :action => "arabic", :page_num => 1
  map.connect "quran/arabic/:page_num", :controller => "quran", :action => "arabic"
  map.connect "quran/arabic/:surah_num.:ayah_num", :controller => "quran", :action => "arabic"

  map.connect "quran/compare", :controller => "quran", :action => "compare", :surah_num => 1, :ayah_num => 1
  map.connect "quran/compare/:surah_num", :controller => "quran", :action => "compare", :ayah_num => 1
  map.connect "quran/compare/:surah_num.:ayah_num", :controller => "quran", :action => "compare"

  # send to quran comparison if no book code given
  map.connect "quran/translate", :controller => "quran",  :action => "compare", :surah_num => 1, :ayah_num => 1
  map.connect "quran/translate/:surah_num", :controller => "quran", :action => "translate", :quran_code => "MAL", :ayah_num => 1
  map.connect "quran/translate/:surah_num.:ayah_num", :controller => "quran", :action => "translate", :quran_code => "MAL"
  map.connect "quran/translate/:quran_code/:surah_num/:rukuh_num", :controller => "quran", :action => "translate"
  map.connect "quran/translate/:quran_code/:surah_num.:ayah_num", :controller => "quran", :action => "translate"

  map.connect "quran/surahs", :controller => "quran",  :action => "surahs"
  map.connect "quran/surahs/:surah_num", :controller => "quran",  :action => "surahs", :quran_code => "MAL"
  map.connect "quran/surahs/:quran_code/:surah_num", :controller => "quran", :action => "surahs"


  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
