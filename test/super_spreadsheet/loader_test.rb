require "test_helper"
require "action_controller"

class SuperSpreadsheetLoaderTest < MiniTest::Spec

  describe "SuperSpreadsheet::Loader" do

    should "have attr_accessor :file_path" do
      spreadsheet = SuperSpreadsheet::Loader.new ""
      assert spreadsheet.respond_to? :file_path
      assert spreadsheet.respond_to? :file_path=
    end

    should "handle invalid file extension" do
      spreadsheet = SuperSpreadsheet::Loader.new "test/support/spreadsheet/file.lol"
      spreadsheet.call
      assert spreadsheet.errors.first.full_message, "File 檔案格式錯誤"
    end

    should "handle empty csv file" do
      spreadsheet = SuperSpreadsheet::Loader.new "test/support/spreadsheet/empty.csv"
      spreadsheet.call
      assert spreadsheet.errors.first.full_message, "檔案內容錯誤，空白檔案"
    end

  end

end
