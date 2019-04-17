require 'test_helper'

describe "ShoplineImportTest" do
  before do
    @spreadsheet = SuperSpreadsheet::Loader.load!('test/support/shopline/export.xls').tap { |s| s.call }
    @service = SuperFormatter::Shopline::Import.new(@spreadsheet)
    @status = @service.call
  end

  should "#call = true" do
    assert @status
  end

  should "#rows.length = 17" do
    assert_equal 17, @service.rows.length
  end

  should "#orders.length = 17" do
    assert_equal 5, @service.result.length
  end

  describe "@row = rows.first" do
    before do
      @row = @service.rows.first
    end

    should "#order_id = '#2019041105080367'" do
      assert_equal '#2019041105080367', @row.order_id
    end

    should "#recipient = 陳子杏" do
      assert_equal '陳子杏', @row.recipient
    end

    should "#shipping_method = 【7-11取貨付款】5-7天配達超商" do
      assert_equal '【7-11取貨付款】5-7天配達超商', @row.shipping_method
    end

    should "#payment_method = －　7-11取貨付款　－" do
      assert_equal '－　7-11取貨付款　－', @row.payment_method
    end


    should "#order_created = 2019/04/11 13:08:03" do
      assert_equal DateTime.parse("2019/04/11 13:08:03"), @row.order_created
    end

    should "#mobile = 0973699403" do
      assert_equal '0973699403', @row.mobile
    end

    should "#store_id = 946207" do
      assert_equal "946207", @row.store_id
    end

    should "#address = 台灣" do
      assert_equal '台灣', @row.address
    end

    should "#total_order_amount = 2427" do
      assert_equal 2427, @row.total_order_amount
    end

    should "#note = nil" do
      assert_nil @row.note
    end

    should "#item_code = 88180828-043" do
      assert_equal '88180828-043', @row.item_code
    end

    should "#item_title = 個性破洞牛仔顯瘦褲 Vol.28" do
      assert_equal '個性破洞牛仔顯瘦褲 Vol.28', @row.item_title
    end

    should "#item_option = 「中高腰」藍色 L-緊身貼腿建議體重【61-70公斤】" do
      assert_equal '「中高腰」藍色 L-緊身貼腿建議體重【61-70公斤】', @row.item_option
    end

    should "#item_qty = 1" do
      assert_equal 1, @row.item_qty
    end

    should "#item_cost = 260" do
      assert_equal 260, @row.item_cost
    end
  end

  describe "@order = result.first" do
    before do
      @order = @service.result.first
    end

    should "#order_id = '2019041105080367'" do
      assert_equal '2019041105080367', @order.order_id
    end

    should "#ref_id = '2019041105080367'" do
      assert_equal '2019041105080367', @order.ref_id
    end

    should "#provider = :UNIMART" do
      assert_equal :UNIMART, @order.provider
    end

    should "#destination = :946207" do
      assert_equal '946207', @order.destination
    end

    should "#order_created_at = 2019/04/11 13:08:03" do
      assert_equal DateTime.parse('2019/04/11 13:08:03'), @order.order_created_at
    end

    should "#cash_on_delivery? = true" do
      assert_equal true, @order.cash_on_delivery?
    end

    should "#warehouse_items.length = 3" do
      assert_equal 3, @order.warehouse_items.length
    end

    should "#warehouse_items" do
      assert_equal '88180828-043', @order.warehouse_items[0].code
      assert_equal 1, @order.warehouse_items[0].qty

      assert_equal '88180827-013', @order.warehouse_items[1].code
      assert_equal 1, @order.warehouse_items[1].qty

      assert_equal '88180829-013', @order.warehouse_items[2].code
      assert_equal 1, @order.warehouse_items[2].qty
    end
  end
end
