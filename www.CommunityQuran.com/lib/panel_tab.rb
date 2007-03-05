class PanelTab
    attr_accessor :label
    attr_accessor :active
    attr_accessor :url

    def initialize(label, active = false, url = nil)
        @label = label
        @active = active
        @url = url
    end
end