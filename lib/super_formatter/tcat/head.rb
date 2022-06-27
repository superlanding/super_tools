module SuperFormatter
  module Tcat
    Head = Struct.new(:data) do
      def indexes
        @indexes ||= {
          global_order_id: data.index("訂單編號"),
          mobile: data.index("手機(收)"),
          recipient: data.index("收件人"),
          tracking_code: data.index("託運單號")
        }
      end
    end
  end
end
