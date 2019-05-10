module SuperFormatter
  Row = Struct.new(:data, :indexes) do
    def method_missing(m)
      find(m)
    end

    def complete?
      indexes.keys.each do |k, i|
        return false if send(k).nil?
      end
      true
    end

    protected

    def find(m)
      i = indexes[m.to_sym]
      i.nil? ? nil : data[i]
    end
  end
end
