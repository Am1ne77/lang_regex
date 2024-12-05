module LangRegex
  module Converter
    module Js
      #
      # Template class implementation.
      #
      class TypeConverter < ::LangRegex::Converter::TypeConverter
        ES2018_HEX_EXPANSION       = '\p{AHex}'
        ES2018_NONHEX_EXPANSION    = '\P{AHex}'
        ES2018_XGRAPHEME_EXPANSION = '[\P{M}\P{Lm}](?:(?:[\u035C\u0361]\P{M}\p{M}*)|\u200d|\p{M}|\p{Lm}|\p{Emoji_Modifier})*'

        private

        def hex_expansion
          if context.es_2018_or_higher? && context.enable_u_option
            ES2018_HEX_EXPANSION
          else
            super
          end
        end

        def nonhex_expansion
          if context.es_2018_or_higher? && context.enable_u_option
            ES2018_NONHEX_EXPANSION
          else
            super
          end
        end

        def xgrapheme
          if context.es_2018_or_higher? && context.enable_u_option
            ES2018_XGRAPHEME_EXPANSION
          else
            super
          end
        end
      end
    end
  end
end
