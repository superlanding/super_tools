module SuperFormatter
  module Hct
    Head = Struct.new(:data) do
      def indexes
        @indexes ||= {
          global_order_id: data.index('訂單號碼') || data.index('清單編號'),
          mobile: data.index('收貨人電話') || data.index('收貨人電話1'),
          recipient: data.index('收貨人') || data.index('收貨人名稱'),
          tracking_code: data.index('查貨號碼') || data.index('十碼貨號')
        }
      end
    end
  end
end