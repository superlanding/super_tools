require 'test_helper'

describe "SuperFormatter::EcanTest" do
  before do
    @spreadsheet = SuperSpreadsheet::Loader.new("test/support/ecan/export.csv").tap { |s| s.call }
    @service = SuperFormatter::Ecan::Import.new(@spreadsheet).tap { |s| s.call }
  end

  should "#result.length = 213" do
    assert_equal 213, @service.result.length
  end

  describe "第一個 row" do
    before do
      @row = @service.result[0]
    end

    should "#global_order_id = C2272" do
      assert_equal 'C2272', @row.global_order_id
    end

    should "#recipient = 連瓊慧" do
      assert_equal '連瓊慧', @row.recipient
    end

    should "#tracking_code = 979010583504-001" do
      assert_equal '979010583504-001', @row.tracking_code
    end
  end

  describe "第2個 row" do
    before do
      @row = @service.result[1]
    end

    should "#global_order_id = C2308" do
      assert_equal 'C2308', @row.global_order_id
    end

    should "#recipient = 劉珈伶" do
      assert_equal '劉珈伶', @row.recipient
    end

    should "#tracking_code = 979010583515-001" do
      assert_equal '979010583515-001', @row.tracking_code
    end
  end
end
