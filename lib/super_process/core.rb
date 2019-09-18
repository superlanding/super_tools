require 'virtus'
module SuperProcess
  class Core
    include ActiveModel::Validations
    include ActiveSupport::Callbacks
    include Virtus.model

    ValidError = Class.new(StandardError)

    define_callbacks :validations, :task

    def self.before_call(method_name)
      set_callback :validations, :before, method_name
    end

    def self.after_call(method_name)
      set_callback :validations, :after, method_name
    end

    def self.before_task(method_name)
      set_callback :task, :before, method_name
    end

    def self.after_task(method_name)
      set_callback :task, :after, method_name
    end

    def self.init(model_name, &block)
      attr_accessor model_name

      class_eval(&block) if block_given?

      define_method :initialize do |model|
        self.send("#{model_name}=", model)
      end
    end

    def self.callable(&block)
      define_method :call! do |params={}|
        params.each do |attr, value|
          public_send("#{attr}=", value) if respond_to?("#{attr}=")
        end
        run_callbacks :validations do
          raise ValidError, "Validation Error" if valid? == false

          run_callbacks :task do
            instance_eval(&block)
          end
        end
      end

      define_method :call do |params={}|
        begin
          @result = call!(params)
          true
        rescue ValidError
          false
        end
      end
    end

    def result
      @result
    end

    def error_messages
      if errors.messages.values.present?
        errors.messages.values.first.first
      else
        ""
      end
    end

    def self.method_missing(m, *args, &block)
      if block_given?
        new.public_send(m, *args, &block)
      else
        new.public_send(m, *args)
      end
    end
  end
end
