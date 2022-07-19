require "super_form/concerns/atomic_save"
require "reform"
require "reform/rails"
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

# Hack Dry::Type 升級 0.15 以後
# 變成強制型別，會造成 params input 空字串時的錯誤
# 這裡是 hack
# https://github.com/apotonick/disposable/blob/master/lib/disposable/twin/coercion.rb
# https://github.com/dry-rb/dry-types/blob/a4983c88299b6f323a769f783cf956629e61f8ed/lib/dry/types/coercions/params.rb#L86

Dry::Types::Coercions::Params.module_eval do
  def self.to_int(input, &block)
    if input.is_a? String
      Integer(input, 10)
    else
      Integer(input)
    end
  rescue ArgumentError, TypeError => e
    return input.to_i if input.respond_to?(:to_i)

    CoercionError.handle(e, &block)
  end
end