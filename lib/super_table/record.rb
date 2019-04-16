require 'forwardable'

module SuperTable
  class Record < Struct.new(:model)
    include ViewHelpers
    extend Forwardable

    delegate_missing_to :model

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
  end
end
