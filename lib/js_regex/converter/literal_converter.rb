require_relative 'base'

module LangRegex
  module Converter
    #
    # Template class implementation.
    #
    class LiteralConverter < Base
      ASTRAL_PLANE_CODEPOINT_PATTERN = /[\u{10000}-\u{10FFFF}]/

      ESCAPES = Hash.new { |h, k| raise KeyError, "#{h}[#{k.inspect}]" }
        .merge("\f\n\r\t\v".chars.to_h { |c| [c, Regexp.escape(c)] })
        .merge('/' => '\\/')
      LITERAL_REQUIRING_ESCAPE_PATTERN = /[\/\f\n\r\t\v]/

      class << self
        def add_escapes(to_escape)
          [
            ESCAPES.dup.merge(to_escape.chars.to_h { |c| [c, "\\#{c}"] }),
            /#{LITERAL_REQUIRING_ESCAPE_PATTERN.source}|[#{to_escape}]/
          ]
        end

        def convert_data(data, context)
          if !context.u? && data =~ ASTRAL_PLANE_CODEPOINT_PATTERN
            if context.enable_u_option
              escape_incompatible_bmp_literals(data, context.target)
            else
              convert_astral_data(data, context.target)
            end
          else
            escape_incompatible_bmp_literals(data, context.target)
          end
        end

        def convert_astral_data(data, target)
          data.each_char.each_with_object(Node.new) do |char, node|
            if char.ord > 0xFFFF
              node << surrogate_substitution_for(char)
            else
              node << escape_incompatible_bmp_literals(char, target)
            end
          end
        end

        def escape_incompatible_bmp_literals(data, target)
          class_name = Target.class_name(target)
          literal_requiring_escape_pattern, escapes =
            if ::LangRegex::Converter.const_defined?("#{class_name}::LiteralConverter")
              literal_converter = ::LangRegex::Converter.const_get("#{class_name}::LiteralConverter")
              if literal_converter.const_defined?('LITERAL_REQUIRING_ESCAPE_PATTERN') \
                 && literal_converter.const_defined?('ESCAPES')
                [literal_converter::LITERAL_REQUIRING_ESCAPE_PATTERN, literal_converter::ESCAPES]
              end
            end \
            || [self::LITERAL_REQUIRING_ESCAPE_PATTERN, self::ESCAPES]
          data.gsub(literal_requiring_escape_pattern, escapes)
        end

        private

        def surrogate_substitution_for(char)
          CharacterSet::Writer.write_surrogate_ranges([], [char.codepoints])
        end
      end

      private

      def convert_data
        result = self.class.convert_data(data, context)
        if context.case_insensitive_root && !expression.case_insensitive?
          warn_of_unsupported_feature('nested case-sensitive literal')
        elsif !context.case_insensitive_root && expression.case_insensitive?
          return handle_locally_case_insensitive_literal(result)
        end
        result
      end

      HAS_CASE_PATTERN = /[\p{lower}\p{upper}]/

      def handle_locally_case_insensitive_literal(literal)
        literal =~ HAS_CASE_PATTERN ? case_insensitivize(literal) : literal
      end

      def case_insensitivize(literal)
        literal.each_char.each_with_object(Node.new) do |chr, node|
          node << (chr =~ HAS_CASE_PATTERN ? "[#{chr}#{chr.swapcase}]" : chr)
        end
      end
    end
  end
end
