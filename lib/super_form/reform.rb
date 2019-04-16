require 'super_form/concerns/atomic_save'

require 'disposable'
require 'reform'
require 'reform/form'
require 'reform/form/active_record'
require 'reform/form/active_model'
require 'reform/form/active_model/form_builder_methods'
require "reform/form/coercion"
require "reform/form/active_model/validations"
require 'disposable/twin/parent'

Reform::Form.class_eval do
  extend ActiveModel::Naming
  extend ActiveModel::Translation
end

class SuperForm::Reform < Reform::Form
  include SuperForm::AtomicSave
  include ::Reform::Form::ActiveRecord
  include ::Reform::Form::ActiveModel
  include ::Reform::Form::ActiveModel::FormBuilderMethods
  feature Coercion

  # 定義 i18n scope
  def self.i18n_prefix(i18n_scope)
    define_singleton_method :i18n_scope do
      i18n_scope.to_sym
    end
  end

  self.i18n_prefix :activerecord

  def self.form_name(name)
    # 定義 form name (給 form 用的)
    define_singleton_method :model_name do
      active_model_name_for(name.to_s.camelize)
    end
    model(name)
  end

  private

  def self.active_model_name_for(string)
    ::ActiveModel::Name.new(self, nil, string)
  end
end
