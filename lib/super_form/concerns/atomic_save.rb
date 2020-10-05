module SuperForm
  module AtomicSave
    extend ActiveSupport::Concern

    included do
      include ActiveSupport::Callbacks

      define_callbacks :transaction, :queries, :validations

      def self.before_transaction(method_name=nil, &block)
        set_defined_callback(:transaction, :before, method_name, &block)
      end

      def self.before_queries(method_name=nil, &block)
        set_defined_callback(:queries, :before, method_name, &block)
      end

      def self.before_commit(method_name=nil, &block)
        set_defined_callback(:queries, :after, method_name, &block)
      end

      def self.after_commit(method_name=nil, &block)
        set_defined_callback(:transaction, :after, method_name, &block)
      end

      def self.before_validations(method_name=nil, &block)
        set_defined_callback(:validations, :before, method_name, &block)
      end

      def self.after_validations(method_name=nil, &block)
        set_defined_callback(:validations, :after, method_name, &block)
      end

      protected

      def self.set_defined_callback(event, callback, method_name=nil, &block)
        raise "wrong number of arguments ('method_name' or 'block' choose one)" if method_name.nil? == false && block.present?
        if block_given?
          set_callback event, callback, &block
        else
          set_callback event, callback, method_name
        end
      end
    end

    ReformAtomicSaveError = Class.new(StandardError)

    def save_with_transaction(params={}, &block)
      begin
        save_with_transaction!(params, &block)
      rescue ReformAtomicSaveError
        false
      end
    end

    def save_with_transaction!(params={}, &block)
      run_callbacks :transaction do
        ActiveRecord::Base.transaction do
          run_callbacks :queries do
            # 1. do validate data
            run_callbacks :validations do
              if validate(params) == false
                raise ReformAtomicSaveError, "Not Validate => #{self.errors.full_messages.inspect}"
              end
            end

            # 2. sync to model
            sync

            # 2. define how to store data in block
            yield if block_given?

            # 3. save all data
            save!
          end
        end
      end
      true
    end
  end
end
