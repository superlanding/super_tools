require "test_helper"
require "action_controller"

class SuperSpreadsheetLoaderTest < MiniTest::Spec

  def parse(path)
    spreadsheet = SuperSpreadsheet::Loader.new "test/support/spreadsheet/#{path}"
    spreadsheet.call
    spreadsheet
  end

  describe "SuperSpreadsheet::Loader" do

    should "have attr_accessor :file_path" do
      spreadsheet = SuperSpreadsheet::Loader.new ""
      assert spreadsheet.respond_to? :file_path
      assert spreadsheet.respond_to? :file_path=
    end

    should "handle invalid file extension" do
      spreadsheet = parse "file.lol"
      assert spreadsheet.errors[:file], "File 檔案格式錯誤"
    end

    should "handle empty csv file" do
      spreadsheet = parse "empty.csv"
      assert spreadsheet.errors[:file], "檔案內容錯誤，空白檔案"
    end

    ["utf8.csv", "big5.csv", "big5-hkscs.csv"].each do |file|
      should "parse #{file}" do
        spreadsheet = parse file
        assert_equal spreadsheet.rows, [["姓名", "電話"], ["許功蓋", "0912-333-456"]]
      end
    end

    should "parse utf8-bom.csv" do
      spreadsheet = parse "utf8-bom.csv"
      # csv parser 會保留 BOM 在第一個 row
      assert_equal spreadsheet.rows, [["\uFEFF姓名", "電話"], ["許功蓋", "0912-333-456"]]
    end

    ["utf8.xlsx", "utf8.xls"].each do |file|
      # excel 檔案會自動將 float 轉 integer
      should "parse #{file}" do
        spreadsheet = parse file
        assert_equal spreadsheet.rows, [["姓名", "電話", "pi"], ["許功蓋", "0912-333-456", 3]]
      end
    end

  end

end
