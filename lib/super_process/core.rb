require "virtus"

module SuperProcess
  class Core
    include ActiveModel::Validations
    include ActiveSupport::Callbacks
    include Virtus.model

    ValidError = Class.new(StandardError)

    CALLBACK_CALL = :"__super_process__call"
    CALLBACK_TASK = :"__super_process__task"

    # https://github.com/rails/rails/blob/v6.1.6/activesupport/lib/active_support/callbacks.rb#L97
    # 這裡透過 define_callbacks define 了 CALLBACK_CALL 與 CALLBACK_TASK
    # 卻沒有 set_callbacks，所以在 run_callbacks 時
    # 會因為找不到儲存的 callback 而直接執行 block
    # 這裡的用法必須注意 rails 內部或是使用此 class 的開發者
    # 不可以使用 CALLBACK_CALL 與 CALLBACK_TASK 相同命名的 callback
    # 否則會有不可預期的副作用
    define_callbacks CALLBACK_CALL, CALLBACK_TASK

    def self.before_call(method_name)
      set_callback CALLBACK_CALL, :before, method_name
    end

    def self.after_call(method_name)
      set_callback CALLBACK_CALL, :after, method_name
    end

    def self.before_task(method_name)
      set_callback CALLBACK_TASK, :before, method_name
    end

    def self.after_task(method_name)
      set_callback CALLBACK_TASK, :after, method_name
    end

    def self.init(model_name, &block)
      attr_accessor model_name

      class_eval(&block) if block_given?

      define_method :initialize do |model|
        super nil
        self.send("#{model_name}=", model)
      end
    end

    def self.callable(&block)
      define_method :call! do |params={}|
        params.each do |attr, value|
          public_send("#{attr}=", value) if respond_to?("#{attr}=")
        end
        run_callbacks CALLBACK_CALL do
          raise ValidError, "Validation Error" if valid? == false
          run_callbacks CALLBACK_TASK do
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

    # 這裡可能需要討論一下是否要更名
    # error_messages ( 複數 )，但 return 出去的是單數 string
    def error_messages
      if errors.messages.values.present?
        errors.messages.values.first.first
      else
        ""
      end
    end

    # 要確認這裡的意圖
    # 如果是有透過 init 設定 model 的 class
    # 底下的 new 會出錯
    def self.method_missing(m, *args, &block)
      if block_given?
        new.public_send(m, *args, &block)
      else
        new.public_send(m, *args)
      end
    end
  end
end
