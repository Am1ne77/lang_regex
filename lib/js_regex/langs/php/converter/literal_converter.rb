module LangRegex
  module Converter
    #
    # Template class implementation.
    #
    module Php
      class LiteralConverter < ::LangRegex::Converter::LiteralConverter
        ESCAPES, LITERAL_REQUIRING_ESCAPE_PATTERN = add_escapes('"\'')
      end
    end
  end
end
