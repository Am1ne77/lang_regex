module LangRegex
  class JavaRegex < LangRegex
    def initialize(ruby_regex, **kwargs)
      super(ruby_regex, self.class.java_converter, target: Target::JAVA, **kwargs)
    end

    def self.java_converter
      Converter::Converter.new(
        {
          expression:  Converter::SubexpressionConverter,
          literal:     Converter::LiteralConverter,
          type:        Converter::Java::TypeConverter
        }
      )
    end

    def to_s
      (options.empty? ? '' : "(?#{options})") << source
    end
  end
end
