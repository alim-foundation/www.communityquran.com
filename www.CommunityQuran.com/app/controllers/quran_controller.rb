class QuranController < ApplicationController
    def index
        @surahs = QuranStructSurah.find(:all)
    end
end
