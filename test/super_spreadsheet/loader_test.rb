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
      assert spreadsheet.errors.first.full_message, "File 檔案格式錯誤"
    end

    should "handle empty csv file" do
      spreadsheet = parse "empty.csv"
      assert spreadsheet.errors.first.full_message, "檔案內容錯誤，空白檔案"
    end

    files = ["utf8.csv", "utf8-bom.csv", "big5.csv", "big5-hkscs.csv", "utf8.xlsx", "utf8.xls"]

    files.each do |file|
      should "parse #{file}" do
        spreadsheet = parse file
        assert spreadsheet.rows, [["姓名", "電話"], ["許功蓋", "0912-333-456"]]
      end
    end

  end

end
