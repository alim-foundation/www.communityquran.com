class QuranController < ApplicationController   
    def index
        self.heading = "Welcome to the Community Qur'an"
    end

    def arabic
        if params[:surah_num] && params[:ayah_num]
            redirect_to :action => "arabic",
                        :page_num => QuranHelper::ARABIC_QURAN.page_ayahs.find_by_surah_num_and_ayah_num(params[:surah_num], params[:ayah_num]).page_num
            return
        end

        self.heading = QuranHelper::ARABIC_QURAN.pages.find_by_page_num(params[:page_num]).ayah_coverage_text
    end

    def search
    end

    def subjects
        
    end

    def compare
        self.heading = "Translations of Surah #{params[:surah_num]}, #{QuranHelper::QURAN_STRUCT.get_surah(Integer(params[:surah_num])).name} Ayah #{params[:ayah_num]}"        
    end

    def translate
        quran = Quran.find_by_code(params[:quran_code])
        self.heading = "#{quran.short_name} translation of Surah #{QuranHelper::QURAN_STRUCT.get_surah(Integer(params[:surah_num])).name} Rukuh #{params[:rukuh_num]}"        
    end

    def surahs
        if ! QuranHelper::QURANS_WITH_SURAH_ELABORATIONS_CODES.include?(params[:quran_code])
            redirect_to :action => "surahs",
                        :quran_code => QuranHelper::QURANS_WITH_SURAH_ELABORATIONS[0].code,
                        :surah_num => params[:surah_num]
            return
        end
        if ! (params[:quran_code] && params[:surah_num])
            redirect_to :action => "surahs",
                        :quran_code => QuranHelper::QURANS_WITH_SURAH_ELABORATIONS[0].code,
                        :surah_num => 1
        else
            self.heading = "Introductory Overview of Surah #{params[:surah_num]}, #{QuranHelper::QURAN_STRUCT.get_surah(Integer(params[:surah_num])).name}"
        end
    end

    def structure
        self.heading = "Structure of the Qur'an"            
    end
end
