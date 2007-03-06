class QuranController < ApplicationController   
    def index
        self.heading = "Welcome to the Community Qur'an"
    end

    def arabic
        if ! (params[:page_num] || (params[:surah_num] && params[:ayah_num]))
            redirect_to :controller => "quran", :action => "arabic",
                        :page_num => 1
        end
        if params[:surah_num] && params[:ayah_num]
            redirect_to :controller => "quran", :action => "arabic",
                        :page_num => QuranHelper::ARABIC_QURAN.pages.find_by_surah_num_and_ayah_num(params[:surah_num], params[:ayah_num]).page_num
        end
    end

    def surahs
        if ! (params[:quran_code] && params[:surah_num])
            redirect_to :controller => "quran", :action => "surahs",
                        :quran_code => QuranHelper::QURANS_WITH_SURAH_ELABORATIONS[0].code,
                        :surah_num => 1
        else
            self.heading = "Introductory Overview of Surah #{params[:surah_num]}, #{QuranHelper::SURAH_STRUCTS[Integer(params[:surah_num])-1].name}"            
        end
    end

    def structure
        self.heading = "Structure of the Qur'an"            
    end
end
