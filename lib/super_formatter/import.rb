module SuperFormatter
  class Import < SuperProcess::Core
    init :spreadsheet
    attr_accessor :head, :rows, :orders

    protected

    def build_rows!(head_klass, row_klass)
      self.head = head_klass.new(spreadsheet.result.shift)
      self.rows = spreadsheet.result.map.with_index do |data, i|
        row_klass.new(data, head.indexes)
      end.compact
    end
  end
end
