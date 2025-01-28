require_relative 'base'

module LangRegex
  module Converter
    #
    # Template class implementation.
    #
    class AnchorConverter < Base
      private

      def convert_data
        case subtype
        when :bol, :eol        then pass_through
        when :bos              then convert_beginning_of_string
        when :eos              then convert_end_of_string
        when :eos_ob_eol       then convert_end_of_string_with_new_line
        when :word_boundary    then convert_boundary
        when :nonword_boundary then convert_nonboundary
        else
          warn_of_unsupported_feature
        end
      end

      def convert_beginning_of_string
        '(?<!.|\n)'
      end

      def convert_boundary
        pass_boundary_with_warning
      end

      def convert_nonboundary
        pass_boundary_with_warning
      end

      def convert_end_of_string
        '(?!.|\n)'
      end

      def convert_end_of_string_with_new_line
        '(?=\n?(?!.|\n))'
      end

      def pass_boundary_with_warning
        warn_of("The anchor '#{data}' at index #{expression.ts} only works "\
                'at ASCII word boundaries with targets below ES2018".')
        pass_through
      end
    end
  end
end
