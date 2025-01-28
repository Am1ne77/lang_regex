module LangRegex
  module Converter
    module Js
      #
      # Template class implementation.
      #
      class AnchorConverter < ::LangRegex::Converter::AnchorConverter
        private

        # This is an approximation to the word boundary behavior in Ruby, c.f.
        # https://github.com/ruby/ruby/blob/08476c45/tool/enc-unicode.rb#L130
        W = '\d\p{L}\p{M}\p{Pc}'

        def convert_boundary
          if context.es_2018_or_higher? && context.enable_u_option
            "(?:(?<=[#{W}])(?![#{W}])|(?<![#{W}])(?=[#{W}]))"
          else
            super
          end
        end

        def convert_nonboundary
          if context.es_2018_or_higher? && context.enable_u_option
            "(?<=[#{W}])(?=[#{W}])"
          else
            super
          end
        end
      end
    end
  end
end
