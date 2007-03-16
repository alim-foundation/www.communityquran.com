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
  map.connect "quran/structure", :controller => "Quran::Structure",  :action => "index"

  map.connect "quran/arabic", :controller => "Quran::Arabic", :action => "index"
  map.connect "quran/arabic/page/:page_num", :controller => "Quran::Arabic", :action => "page"
  map.connect "quran/arabic/ayah/:surah_num.:ayah_num", :controller => "Quran::Arabic", :action => "ayah"

  map.connect "quran/compare", :controller => "Quran::Translate", :action => "compare"
  map.connect "quran/compare/:surah_num", :controller => "Quran::Translate", :action => "redirect_compare_surah"
  map.connect "quran/compare/:surah_num.:ayah_num", :controller => "Quran::Translate", :action => "compare_surah_ayah"

  map.connect "quran/translate", :controller => "Quran::Translate",  :action => "translate"
  map.connect "quran/translate/surah/:surah_num", :controller => "Quran::Translate", :action => "redirect_translate_surah"
  map.connect "quran/translate/rukuh/:surah_num.:rukuh_num", :controller => "Quran::Translate", :action => "redirect_translate_surah_rukuh"
  map.connect "quran/translate/ayah/:surah_num.:ayah_num", :controller => "Quran::Translate", :action => "redirect_translate_surah_ayah"
  map.connect "quran/translate/:quran_code/surah/:surah_num", :controller => "Quran::Translate", :action => "translate_surah"
  map.connect "quran/translate/:quran_code/rukuh/:surah_num.:rukuh_num", :controller => "Quran::Translate", :action => "translate_surah_rukuh"
  map.connect "quran/translate/:quran_code/ayah/:surah_num.:ayah_num", :controller => "Quran::Translate", :action => "translate_surah_ayah"

  map.connect "quran/subjects", :controller => "Quran::Subjects",  :action => "index"
  map.connect "quran/subjects/:letter", :controller => "Quran::Subjects",  :action => "redirect_letter"
  map.connect "quran/subjects/:quran_code/:letter", :controller => "Quran::Subjects",  :action => "letter"
  map.connect "quran/subjects/:subject_id/locations", :controller => "Quran::Subjects",  :action => "locations"
  map.connect "quran/subjects/:subject_id/ayahs", :controller => "Quran::Subjects",  :action => "ayahs"

  map.connect "quran/surahs", :controller => "Quran::Surah",  :action => "index"
  map.connect "quran/surahs/:surah_num", :controller => "Quran::Surah",  :action => "redirect_surah_num"
  map.connect "quran/surahs/:quran_code/:surah_num", :controller => "Quran::Surah", :action => "surahs"

  map.connect "quran/search", :controller => "Quran::Search",  :action => "index"
  map.connect "quran/search/:expression", :controller => "Quran::Search",  :action => "search"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'
end
