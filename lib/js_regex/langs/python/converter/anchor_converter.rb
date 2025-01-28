module LangRegex
  module Converter
    module Python
      #
      # Template class implementation.
      #
      class AnchorConverter < ::LangRegex::Converter::AnchorConverter
        private

        def convert_beginning_of_string
          '\A'
        end

        def convert_boundary
          '\b'
        end

        def convert_nonboundary
          '\B'
        end

        def convert_end_of_string
          '\Z'
        end
      end
    end
  end
end
