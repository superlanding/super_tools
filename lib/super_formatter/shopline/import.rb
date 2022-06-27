require "super_formatter/import"
require "super_formatter/shopline/head"
require "super_formatter/shopline/row"
require "super_formatter/shopline/order"

module SuperFormatter
  module Shopline
    class Import < ::SuperFormatter::Import

      callable do
        build_rows!(Head, Row)

        self.orders = merged_orders!.values

        self.orders
      end

      protected

      def merged_orders!
        array = {}
        rows.each do |row|
          if array[row.order_id].present?
            # 存在 Merge Item
            array[row.order_id].merge!(row)
          else
            # 不存在建立 Order
            array[row.order_id] = Order.new(row)
          end
        end
        array
      end
    end
  end
end
