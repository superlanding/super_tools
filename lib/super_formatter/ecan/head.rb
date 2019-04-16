module SuperFormatter
  module Ecan
    Head = Struct.new(:data) do
      def indexes
        @indexes ||= {
          global_order_id: data.index('客戶單號'),
          recipient: data.index('收件人'),
          tracking_code: data.index('宅配單號')
        }
      end
    end
  end
end