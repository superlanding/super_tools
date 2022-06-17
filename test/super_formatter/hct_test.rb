require 'test_helper'

describe "SuperFormatter::Hct" do
  describe "錯誤的 Encode CSV" do
    before do
      @spreadsheet = SuperSpreadsheet::Loader.new("test/support/hct/encoding_fail.csv").tap { |s| s.call }
      @service = SuperFormatter::Hct::Import.new(@spreadsheet).tap { |s| s.call }
    end

    should "#result.length = 22" do
      assert_equal 22, @service.result.length
    end

    describe "第一個 row" do
      before do
        @row = @service.result.first
      end

      should "#global_order_id = JB0413來回-1" do
        assert_equal 'JB0413來回-1', @row.global_order_id
      end

      should "#recipient = 羅雅薰" do
        assert_equal '羅雅薰', @row.recipient
      end

      should "#mobile = 0906738970" do
        assert_equal '0906738970', @row.mobile
      end

      should "#tracking_code = 1349172344" do
        assert_equal '1349172344', @row.tracking_code
      end
    end
  end

  describe "單機版 CSV" do
    before do
      @spreadsheet = SuperSpreadsheet::Loader.new("test/support/hct/local.csv").tap { |s| s.call }
      @service = SuperFormatter::Hct::Import.new(@spreadsheet).tap { |s| s.call }
    end

    should "#result.length == 78" do
      assert_equal 78, @service.result.length
    end

    describe "第一個 row" do
      before do
        @row = @service.result.first
      end

      should "#global_order_id = TM190330R00371" do
        assert_equal 'TM190330R00371', @row.global_order_id
      end

      should "#recipient = 何孟芳" do
        assert_equal '何孟芳', @row.recipient
      end

      should "#mobile = 0935725725" do
        assert_equal '0935725725', @row.mobile
      end

      should "#tracking_code = 1349168343" do
        assert_equal '1349168343', @row.tracking_code
      end
    end
  end

  describe "雲端版 CSV" do
    before do
      @spreadsheet = SuperSpreadsheet::Loader.new("test/support/hct/cloud.csv").tap { |s| s.call }
      @service = SuperFormatter::Hct::Import.new(@spreadsheet).tap { |s| s.call }
    end

    should "#result.length == 78" do
      assert_equal 243, @service.result.length
    end

    describe "第一個 row" do
      before do
        @row = @service.result.first
      end

      should "#global_order_id = SC14119" do
        assert_equal 'SC14119', @row.global_order_id
      end

      should "#recipient = 陳凱文" do
        assert_equal '陳凱文', @row.recipient
      end

      should "#mobile = 0963026178" do
        assert_equal '0963026178', @row.mobile
      end

      should "#tracking_code = 6776683723" do
        assert_equal '6776683723', @row.tracking_code
      end
    end
  end
end
