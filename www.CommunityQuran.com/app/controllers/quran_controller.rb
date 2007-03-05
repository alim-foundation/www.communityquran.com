class QuranController < ApplicationController   
    def index
        self.heading = "Welcome to the Community Qur'an"
    end

    def surahs
        if ! (params[:quran_code] && params[:surah_num])
            redirect_to :controller => "quran", :action => "surahs",
                        :quran_code => Quran.find_by_contains_surah_elaborations(true).code,
                        :surah_num => 1
        else
            self.heading = "Introductory Overview of Surah #{params[:surah_num]}"            
        end
    end
end
