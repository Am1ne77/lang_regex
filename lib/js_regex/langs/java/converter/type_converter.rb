module LangRegex
  module Converter
    module Java
      #
      # Template class implementation.
      #
      class TypeConverter < ::LangRegex::Converter::TypeConverter
        def convert_data
          case subtype
          when :digit, :space, :word, :nondigit, :nonspace, :nonword
            Regexp.escape(expression)
          else
            super
          end
        end
      end
    end
  end
end
