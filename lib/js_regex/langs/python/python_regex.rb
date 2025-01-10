module LangRegex
  class PythonRegex < LangRegex
    def initialize(ruby_regex, **kwargs)
      super(ruby_regex, self.class.python_converter, target: Target::PYTHON, **kwargs)
    end

    def self.python_converter
      Converter::Converter.new(
        {
          expression:  Converter::SubexpressionConverter,
          literal:     Converter::LiteralConverter,
          type:        Converter::TypeConverter
        }
      )
    end

    def to_s
      (options.empty? ? '' : "(?#{options})") << source
    end
  end
end
