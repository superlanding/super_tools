module SuperValue
  class Base
    include ActiveSupport::Callbacks
    cattr_accessor :model_name
    define_callbacks :init

    class << self
      def init(model_name)
        self.model_name = model_name
        self.send(:attr_accessor, model_name)
        define_method :initialize do |model|
          run_callbacks :init do
            self.send("#{model_name}=", model)
          end
        end
      end

      def property(method_name)
        delegate method_name, to: model_name
      end

      def before_init(method_name=nil, &block)
        if block_given?
          set_callback :init, :before, &block
        else
          set_callback :init, :before, method_name
        end
      end

      def after_init(method_name=nil, &block)
        if block_given?
          set_callback :init, :after, &block
        else
          set_callback :init, :after, method_name
        end
      end
    end
  end
end
