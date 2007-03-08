class SurahNavigator
    attr_accessor :panel_heading
    attr_accessor :label
    attr_accessor :action
    attr_accessor :ayah_num
    attr_accessor :ayahs_navigator
    attr_accessor :ayahs_navigator_separator

    def initialize(attributes = {})
        # TODO: figure out if this is the right ruby idiom to do attribute assignments based on a hash -- eval seems expensive?
        attributes.each do |name, value|
            eval "self.#{name} = value"
        end
    end
end