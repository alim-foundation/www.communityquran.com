class Panel
    attr_accessor :tabs
    attr_accessor :body

    def initialize(*args)
        @tabs = []
        if args.length == 2
            add_tab(args[0], true)
            @body = args[1]
        end
    end

    def add_tab(*args)
       @tabs << PanelTab.new(*args)
    end
end