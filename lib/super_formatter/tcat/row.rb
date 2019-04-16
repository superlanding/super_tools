require 'super_formatter/row'
module SuperFormatter
  module Tcat
    class Row < ::SuperFormatter::Row

      def tracking_code
        (find(:tracking_code) || "").gsub("'", '')
      end
      
      def mobile
        @mobile ||= begin
          text = (find(:mobile) || "").gsub("'", "")
          if text[0] == '9' && text.length == 9
            "0#{text}"
          else
            text
          end
        end
      end
    end
  end
end
