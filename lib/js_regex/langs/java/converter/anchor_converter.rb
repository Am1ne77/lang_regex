module LangRegex
  module Converter
    module Java
      #
      # Template class implementation.
      #
      class AnchorConverter < ::LangRegex::Converter::AnchorConverter
        private

        def convert_beginning_of_string
          '\\\\A'
        end

        # Despite \b and \B existing in Java regexes, they do not behave the
        # same way for some utf-8 characters.
        # This is an approximation to the word boundary behavior in Ruby, c.f.
        # https://github.com/ruby/ruby/blob/08476c45/tool/enc-unicode.rb#L130
        W = '\\\\d\\\\p{L}\\\\p{M}\\\\p{Pc}'

        def convert_boundary
          "(?:(?<=[#{W}])(?![#{W}])|(?<![#{W}])(?=[#{W}]))"
        end

        def convert_nonboundary
          "(?<=[#{W}])(?=[#{W}])"
        end

        def convert_end_of_string
          '\\\\z'
        end

        def convert_end_of_string_with_new_line
          '\\\\Z'
        end
      end
    end
  end
end
