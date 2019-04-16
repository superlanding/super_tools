require 'test_helper'

describe "SuperFormatter::Tcat" do
  before do
    @spreadsheet = SuperSpreadsheet::Loader.new("test/support/tcat/export.csv").tap { |s| s.call }; ""
    @service = SuperFormatter::Tcat::Import.new(@spreadsheet).tap { |s| s.call }; ""
  end

  should "#result.length = 34" do
    assert_equal 34, @service.result.length
  end

  describe "第一個 row" do
    before do
      @row = @service.result[0]
    end

    should "#global_order_id = MB40881" do
      assert_equal 'MB40881', @row.global_order_id
    end

    should "#recipient = 黃齡萱" do
      assert_equal '黃齡萱', @row.recipient
    end

    should "#mobile = 0977481414" do
      assert_equal '0977481414', @row.mobile
    end

    should "#tracking_code = 625270211891" do
      assert_equal '625270211891', @row.tracking_code
    end
  end

  describe "第2個 row" do
    before do
      @row = @service.result[1]
    end

    should "#global_order_id = MB40882" do
      assert_equal 'MB40882', @row.global_order_id
    end

    should "#recipient = 翁采慧" do
      assert_equal '翁采慧', @row.recipient
    end

    should "#mobile = 0907343512" do
      assert_equal '0907343512', @row.mobile
    end

    should "#tracking_code = 625270211900" do
      assert_equal '625270211900', @row.tracking_code
    end
  end
end
