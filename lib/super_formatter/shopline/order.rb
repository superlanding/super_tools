require 'warehouse'
module SuperFormatter
  module Shopline
    class Order
      attr_accessor :row
      attr_accessor :items_array, :warehouse_items

      delegate :recipient, to: :row
      delegate :mobile, to: :row
      delegate :total_order_amount, to: :row
      delegate :store_id, to: :row
      delegate :note, to: :row

      def order_id
        row.order_id.gsub("#", '')
      end

      def initialize(row)
        self.row = row
        merge!(row)
      end

      def provider
        @provider ||= case
        when row.shipping_method.include?('7-11')
          :UNIMART
        when row.shipping_method.include?('全家')
          :FAMI
        when row.shipping_method.include?('新竹')
          :HCT
        when row.shipping_method.include?('黑貓')
          :TCAT
        else
          nil
        end
      end

      def ref_id
        order_id
      end

      def destination
        @destination ||= case provider
        when :UNIMART, :FAMI
          store_id
        when :HCT, :TCAT
          address
        end
      end

      def address
        row.address.gsub("台灣", "")
      end

      def order_created_at
        row.order_created
      end

      def cash_on_delivery?
        if row.payment_method.include?('取貨付款')
          true
        else
          false
        end
      end

      def only_delivery?
        !cash_on_delivery?
      end

      def paid?
        row.payment_status == '已付款'
      end

      def items
        items_array.join(" ")
      end

      def merge!(row)
        self.items_array ||= []
        self.warehouse_items ||= Warehouse::List.new

        self.items_array << "#{row.item_title}-#{row.item_option}*#{row.item_qty}"
        self.warehouse_items += Warehouse::Item::Code.new(row.item_code, row.item_code, row.item_qty)
      end
    end
  end
end
