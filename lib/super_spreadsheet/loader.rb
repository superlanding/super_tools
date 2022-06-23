require "csv"
require "roo"
require "roo-xls"

module SuperSpreadsheet
  class Loader < SuperProcess::Core
    attr_accessor :file_path
    validate :valid_format

    def self.load!(file)
      new(file)
    end

    def initialize(file_path)
      @file_path = file_path
    end

    callable do
      rows
    end

    def extension
      ::File.extname(file_path).split(".").last.force_encoding("utf-8").downcase
    end

    def valid_format
      if rows == false
        errors.add(:file, "檔案格式錯誤")
      elsif rows.flatten.empty?
        errors.add(:file, "檔案內容錯誤，空白檔案")
      end
    end

    def rows
      @rows ||= rows!
    end

    protected

    def rows!
      case extension
      when "xls"
        ::Roo::Excel.new(file_path).map { |row| convert_float_to_integer(row) }
      when "xlsx"
        ::Roo::Excelx.new(file_path).map { |row| convert_float_to_integer(row) }
      when "csv"
        ::CSV.parse(csv_content!)
      else
        false
      end
    rescue
      false
    end

    def csv_content!
      @decode_csv_content ||= begin
        csv_content_big5!
      rescue
        begin
          csv_content_big5_hkscs!
        rescue
          csv_content
        end
      end
    end

    def csv_content
      @csv_content ||= File.read(file_path)
    end

    private

    def csv_content_big5!
      csv_content.encode!(Encoding::UTF_8, Encoding::BIG5, invalid: :replace, undef: :replace, replace: "")
    end

    def csv_content_big5_hkscs!
      csv_content.encode!(Encoding::UTF_8, Encoding::BIG5_HKSCS, invalid: :replace, undef: :replace, replace: "")
    end

    def convert_float_to_integer(row)
      row.map do |cell|
        if cell.is_a?(Float) && cell = cell.to_i
          cell.to_i
        else
          cell
        end
      end
    end
  end
end
