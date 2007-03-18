# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
    # Pick a unique cookie name to distinguish our session data from others'
    session :session_key => '_www.CommunityQuran.com_session_id'

    attr_accessor :title
    attr_accessor :heading
    attr_accessor :page_navigation

protected
    def title=(title)
        @title = title
        @heading = title unless @heading
    end

    def heading=(heading)
        @heading = heading
        @title = heading unless @title
    end

    def page_navigation=(pn)
        @page_navigation = pn
    end
end
