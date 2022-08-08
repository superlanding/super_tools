require "test_helper"

describe "SuperTable::TableableTest" do
  include BuildOrdersHelper

  class TestSuperTable < SuperTable::Tableable
    column :ship_no, "訂單編號"
    column :recipient, "收件人", desc: "姓名 / 電話"

    collection :orders do
      property :ship_no

      def ship_no_text
        "訂單編號_#{ship_no}"
      end

      def recipient
        "李大同 #{content_tag(:small, "0972333333")}"
      end
    end
  end

  before do
    @orders = build_orders
    @table = TestSuperTable.new(@orders)
  end

  describe "#collection" do
    before do
      @collection = @table.collection
    end

    should "2 筆" do
      assert_equal(2, @collection.length)
    end

    should "回傳 Array" do
      assert_kind_of(Array, @collection)
    end
  end

  should "2 筆訂單資料" do
    assert_equal(2, @table.orders.length)
  end

  should "#placeholder" do
    assert_nil(@table.placeholder)
  end

  describe "第一筆訂單" do
    before do
      @order = @table.orders.first
    end

    should "instance of " do
      assert_kind_of(SuperTable::Record, @order)
    end

    should "#ship_no = 000123" do
      assert_equal("訂單編號_000108", @order.ship_no_text)
    end

    should "#recipient" do
      assert_equal("李大同 <small>0972333333</small>", @order.recipient)
    end
  end

  class TestInheritTable < TestSuperTable
    column :amount, "金額"
    column :ship_no, "訂單編號 [*]"

    collection :orders do
      def ship_no_text
        "#{super} XX"
      end
    end
  end

  describe "繼承時..." do
    before do
      @table = TestInheritTable.new(@orders)
    end

    should ".columns 裡應該要有 ship_no, recipient, amount" do
      assert_equal([ :ship_no, :recipient, :amount ], TestInheritTable.columns.keys)
    end

    should ".columns[:ship_no]" do
      assert_equal({ title: "訂單編號 [*]" }, TestInheritTable.columns[:ship_no])
    end

    describe "第一筆訂單資料" do
      before do
        @order = @table.collection.first
      end

      should "#ship_no" do
        assert_equal("訂單編號_000108 XX", @order.ship_no_text)
      end

      should "#recipient" do
        assert_equal("李大同 <small>0972333333</small>", @order.recipient)
      end
    end
  end
end
