module SuperTable
  class Tableable
    include ViewHelpers

    attr_accessor :records
    class_attribute :columns
    class_attribute :record_klass

    delegate :columns, to: :class

    def initialize(records)
      self.records = records
    end

    def placeholder; end

    class << self

      def column(method_name, title, options={})
        self.columns ||= {}
        self.columns[method_name] = options.merge(title: title)
      end

      def collection(records_name, options={}, &block)
        parent_klass = ancestors.find { |klass|
          klass.respond_to?(:record_klass) && klass.record_klass.present?
        }
        self.record_klass = if parent_klass
          Class.new(parent_klass.record_klass, &block)
        else
          Class.new(SuperTable::Record, &block)
        end

        define_method(records_name) do
          @collection ||= self.records.map { |record| record_klass.new(record) }
        end

        define_method(:collection) do
          send(records_name)
        end
      end
    end
  end
end
