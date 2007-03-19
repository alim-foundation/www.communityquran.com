class Quran::SubjectController < QuranController
    @qurans_with_subjects = nil

    def qurans_with_subjects
        @qurans_with_subjects ||= Quran.find_all_by_contains_subjects(true)
        return @qurans_with_subjects
    end

    def default_index_quran_code
        return "QSB"
    end

    def index
        redirect_to :action => 'category', :letter => 'A', :quran_code => default_index_quran_code
    end

    def redirect_category
        redirect_to :action => 'category', :letter => params[:letter] || 'A', :quran_code => default_index_quran_code
    end

    def category
        unless get_active_subjects_index
            redirect_to :action => 'category', :quran_code => default_index_quran_code, :letter => params[:letter]
            return
        end

        @letter = params[:letter] || 'A'
        @category_subjects = @quran.subject_letters.find_by_letter(@letter).subjects.find(:all, :order => 'topic', :conditions => 'parent_id is null')

        self.heading = "Subjects starting with letter '#{params[:letter]}'"
    end

    def topic
        unless get_active_subjects_index
            redirect_category
            return
        end

        @subject = QuranSubject.find_by_id(params[:subject_id])
        self.heading = "#{@subject.full_topic_path}"
    end

    def redirect_ayahs
        redirect_to :action => 'ayahs', :view_quran_code => 'MAL'
    end

    def ayahs
        unless get_active_subjects_index
            redirect_category
            return
        end

        @view_quran = Quran.find_by_code(params[:view_quran_code])
        if !@view_quran
            ayahs_redirect
            return
        end

        @subject = QuranSubject.find_by_id(params[:subject_id])
        @ayahs = @subject.locations.collect { |location|
            @view_quran.ayahs.find_by_surah_num_and_ayah_num(location.surah_num, location.ayah_num)
        }
        self.heading = "#{@subject.full_topic_path}"
    end

private
    def get_active_subjects_index
        @quran = Quran.find_by_code(active_quran_code)
        if ! @quran
            return false
        end

        @subject_letters = @quran.subject_letters.find(:all, :order => 'letter')
        return true
    end
end
