module SuperFormatter
  module Shopline
    Head = Struct.new(:data) do
      def indexes
        @indexes ||= {
          order_id: data.index('訂單號碼'),
          order_created: data.index('訂單日期'),
          shipping_method: data.index('送貨方式'),
          payment_method: data.index('付款方式'),
          payment_status: data.index('付款狀態'),
          recipient: data.index('收件人'),
          mobile:  data.index('收件人電話號碼'),
          store_id: data.index('全家服務編號 / 7-11 店號'),
          address: data.index('完整地址'),
          total_order_amount: data.index('訂單合計'),
          note: data.index('送貨備註'),
          item_title: data.index('商品名稱'),
          item_option: data.index('選項'),
          item_code: data.index('商品貨號'),
          item_qty: data.index('數量'),
          item_cost: data.index('商品成本')
        }
      end
    end
  end
end
