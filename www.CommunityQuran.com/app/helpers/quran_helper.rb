module QuranHelper

    def search_for_expression
        return QuranAyah.find_id_by_contents(params[:expression])

    end

end
