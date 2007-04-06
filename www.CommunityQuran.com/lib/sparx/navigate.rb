module Sparx::Navigate

    class Tree
        attr_reader :root

        def initialize(id, options = {})
            @root = Path.new(self, id, options)
            yield @root if block_given?               
        end
    end

    class Node
        attr_reader :tree
        attr_reader :parent

        def initialize(tree,  options = {})
            @tree = tree
        end

        def is_separator?
            return false
        end

        def is_path?
            return false
        end

    protected
        def parent=(parent)
            @parent = parent
        end
    end

    class Separator < Node
        def initialize(tree,  options = {})
            super(tree, options)
        end

        def is_separator?
            return true
        end
    end

    class Path < Node
        attr_reader :id
        attr_reader :children
    
        attr_accessor :current
        attr_accessor :label
        attr_accessor :style
        attr_accessor :url
        attr_accessor :link
        attr_accessor :disabled

        def initialize(tree, id, options = {})
            super(tree)
            @id = id
            @children = []
            @active = options[:active]
            @label = options[:label]
            @style = options[:style]
            @url = options[:url]
            @link = options[:link]
            @disabled = options[:disabled]
        end

        def is_path?
            return true
        end

        def is_current?
            return self.current
        end

        def add_path(id, options = {})
            child = Path.new(self.tree, id, options)
            child.parent = self
            yield child if block_given?
            @children << child
            return child
        end

        def add_separator(options = {})
            child = Separator.new(self.tree, options)
            child.parent = self
            yield child if block_given?
            @children << child
            return child
        end
    end

    class Callout
        attr_accessor :body

        def initialize(options = {})
            @body = options[:body]
        end
    end

end    
    