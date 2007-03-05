# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
    # Pick a unique cookie name to distinguish our session data from others'
    session :session_key => '_www.CommunityQuran.com_session_id'

    #{The title of a page, what shows up in the <title> tag.}
    @title = nil

    #{The heading of a page, what shows up in the content/layout.}
    @heading = nil

protected
    def title=(title)
        @title = title
        @heading = title unless @heading
    end

    def heading=(heading)
        @heading = heading
        @title = heading unless @title
    end
end
