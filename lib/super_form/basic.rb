require 'virtus'
module SuperForm
  class Basic
    include ActiveModel::Model
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include Virtus.model

    def sync_params(params)
      params.each do |attr, value|
        public_send("#{attr}=", value) if respond_to?("#{attr}=")
      end
    end

    class << self
      def form_name(name)
        # 定義 form name (給 form 用的)
        define_singleton_method :model_name do
          active_model_name_for(name.to_s.camelize)
        end
      end

      # default is forms
      def i18n_scope
        :forms
      end

      # 定義 i18n scope
      def i18n_prefix(i18n_scope)
        define_singleton_method :i18n_scope do
          i18n_scope.to_sym
        end
      end

      private

      def active_model_name_for(string)
        ::ActiveModel::Name.new(self, nil, string)
      end
    end
  end
end
