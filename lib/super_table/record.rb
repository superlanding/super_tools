require 'forwardable'

module SuperTable
  class Record < Struct.new(:model)
    include ViewHelpers
    extend Forwardable

    class << self

      def property(attr_name)
        def_delegator :model, attr_name
      end
    end

    def helpers
      @helpers ||= Class.new do
        include ViewHelpers
      end.new
    end

    private

    def respond_to_missing?(name, include_private = false)
      model.respond_to?(name, include_private)
    end

    def method_missing(method, *args, &block)
      model.send(method, *args, &block)
    end
  end
end
