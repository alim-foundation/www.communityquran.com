class QuranController < ApplicationController
    @quran_struct = nil

    def index
        render(:layout => false) 
    end

    def quran_struct
        @quran_struct ||= QuranStruct.find(:first)
        return @quran_struct
    end

    def active_quran_code
        return params[:quran_code]
    end

    def active_surah_num
        return Integer(params[:surah_num])
    end

    def active_ayah_num
        return Integer(params[:ayah_num])
    end

    def active_rukuh_num
        return Integer(params[:rukuh_num])
    end

    def active_surah_struct
        return quran_struct.get_surah(active_surah_num)
    end

    def add_surah_paths(path, action, prevNext = true, ayahNum = nil, hideIntro = false)
        activeSurahNum = active_surah_num
        path.add_path 'view-surah-intro', :label => "View Surah Introduction", :url => url_for(:controller => 'Quran::Surah', :action => 'redirect_elaborate_surah_num') unless hideIntro
        path.add_path 'goto-surah', :label => 'Goto Surah', :style => :pull_down_menu do |c|
            if prevNext then
                c.add_path 'prev-surah', :label => "Previous Surah", :url => get_previous_surah_url(action, ayahNum)
                c.add_path 'next-surah', :label => "Next Surah", :url => get_next_surah_url(action, ayahNum)
                c.add_separator
            end
            quran_struct.surahs.each do |surah|
                c.add_path "Surah_#{surah.surah_num}",
                          :label => "#{surah.surah_num}. #{surah.name}",
                          :url => ayahNum ? url_for(:action => action, :surah_num => surah.surah_num, :ayah_num => ayahNum) : url_for(:action => action, :surah_num => surah.surah_num),
                          :current => surah.surah_num == activeSurahNum
            end
        end
    end

    def add_surah_ayah_paths(path, action, prevNext = true)
        activeSurahStruct = active_surah_struct
        activeAyahNum = active_ayah_num
        if prevNext then
            path.add_path 'prev-ayah', :label => "Goto Previous Ayah", :url => get_previous_ayah_url(action)
            path.add_path 'next-ayah', :label => "Goto Next Ayah", :url => get_next_ayah_url(action)
        end
        path.add_path 'goto-ayah', :label => 'Goto Ayah', :style => :pull_down_menu do |c|
            for ayah_num in (1..activeSurahStruct.ayah_count)
                c.add_path "Surah_#{activeSurahStruct.surah_num}_Ayah_#{ayah_num}",
                          :label => "#{ayah_num}",
                          :url => url_for(:action => action, :surah_num => activeSurahStruct.surah_num, :ayah_num => ayah_num),
                          :current => ayah_num == activeAyahNum
            end
        end
    end

    def add_surah_rukuh_paths(path)
        activeSurahStruct = active_surah_struct
        if activeSurahStruct.rukuh_count == 0
            return
        end

        activeRukuhNum = active_rukuh_num
        path.add_path 'goto-rukuh', :label => 'Goto Rukuh', :style => :pull_down_menu do |c|
            for rukuh in activeSurahStruct.rukuhs do
                c.add_path "Surah_#{activeSurahStruct.surah_num}_Rukuh_#{rukuh.rukuh_num}",
                          :label => "#{rukuh.rukuh_num} (Ayahs #{rukuh.start_ayah_num} to #{rukuh.end_ayah_num})",
                          :url => url_for(:rukuh_num => rukuh.rukuh_num),
                          :current => rukuh.rukuh_num == activeRukuhNum
            end
        end
    end

    def get_previous_surah_url(action, ayahNum)
        surahNum = active_surah_num
        if surahNum > 1
            surahNum -= 1
        else
            surahNum = quran_struct.surah_count
        end
        return ayahNum ? url_for(:action => action, :surah_num => surahNum, :ayah_num => ayahNum) : url_for(:action => action, :surah_num => surahNum)
    end

    def get_next_surah_url(action, ayahNum)
        surahNum = active_surah_num
        if surahNum < quran_struct.surah_count
            surahNum += 1
        else
            surahNum = 1
        end
        return ayahNum ? url_for(:action => action, :surah_num => surahNum, :ayah_num => ayahNum) : url_for(:action => action, :surah_num => surahNum)
    end

    def get_previous_ayah_url(action)
        surahNum = active_surah_num
        ayahNum = active_ayah_num
        if ayahNum > 1
            ayahNum -= 1
        else
            if surahNum > 1
                surahNum -= 1
            else
                surahNum = quran_struct.surah_count
            end
            ayahNum = quran_struct.get_surah(surahNum).ayah_count
        end
        url_for :action => action, :surah_num => surahNum, :ayah_num => ayahNum
    end

    def get_next_ayah_url(action)
        surahNum = active_surah_num
        ayahNum = active_ayah_num
        if ayahNum < quran_struct.get_surah(surahNum).ayah_count
            ayahNum += 1
        else
            if surahNum < quran_struct.surah_count
                surahNum += 1
            else
                surahNum = 1
            end
            ayahNum = 1
        end
        url_for :action => action, :surah_num => surahNum, :ayah_num => ayahNum
    end

end
