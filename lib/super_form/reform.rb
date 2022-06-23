require "super_form/concerns/atomic_save"
require "reform"
require "reform/form"
require "reform/active_record"
require "reform/form/coercion"
require "disposable"
require "disposable/twin/parent"

class SuperForm::Reform < Reform::Form
  include SuperForm::AtomicSave
  extend ::ActiveModel::Translation
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
      active_model_name_for(name.to_s.camelize) # Reform::Form::ActiveModel
    end
    # NOTE: 這行很可能沒有作用
    model(name)
  end
end
