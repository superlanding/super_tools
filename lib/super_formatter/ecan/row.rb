require "super_formatter/row"

module SuperFormatter
  module Ecan
    class Row < ::SuperFormatter::Row

      def global_order_id
        order_id = (find(:global_order_id) || "")
        if order_id[0] == "C"
          order_id[1, order_id.length - 1]
        else
          order_id
        end
      end
    end
  end
end
