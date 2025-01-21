module LangRegex
  class PhpRegex < LangRegex
    Dir[File.join(__dir__, 'converter', '*.rb')].sort.each do |file|
      require file
    end

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
