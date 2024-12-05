module LangRegex
  class PhpRegex < LangRegex
    def initialize(ruby_regex, **kwargs)
      super(ruby_regex, self.class.php_converter, target: Target::PHP, **kwargs)
    end

    def self.php_converter
      Converter::Converter.new(
        {
          expression:  Converter::SubexpressionConverter,
          literal:     Converter::LiteralConverter,
          type:        Converter::TypeConverter
        }
      )
    end
  end
end
