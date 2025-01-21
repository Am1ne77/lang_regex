module LangRegex
  module Target
    JAVA   = 'JAVA'

    ES2009 = 'ES2009'
    ES2015 = 'ES2015'
    ES2018 = 'ES2018'
    JS     = [ES2009, ES2015, ES2018].freeze

    PHP    = 'PHP'

    PYTHON = 'PYTHON'

    FULLY_SUPPORTED = [*JS].freeze
    PARTIALLY_SUPPORTED = [JAVA, PHP, PYTHON].freeze
    SUPPORTED = [*FULLY_SUPPORTED, *PARTIALLY_SUPPORTED].freeze

    def self.cast(arg)
      return ES2009 if arg.nil?
      return arg if SUPPORTED.include?(arg)

      normalized_arg = arg.to_s.upcase.sub(/^(ECMASCRIPT|ES|JAVASCRIPT|JS)? ?/, 'ES')
      return normalized_arg if SUPPORTED.include?(normalized_arg)

      raise ArgumentError.new(
        "Unknown target: #{arg.inspect}. Try one of #{SUPPORTED}."
      ).extend(::LangRegex::Error)
    end

    def self.class_name(arg)
      res = cast(arg)
      if /ES20\d\d/.match? res
        'js'
      else
        res
      end.capitalize
    end
  end
end
