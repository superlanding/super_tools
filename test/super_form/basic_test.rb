require "test_helper"
require "action_controller"

describe "SuperForm::BasicTest" do

  class EmptyForm < SuperForm::Basic
  end

  class FormWithFormName < SuperForm::Basic
    form_name :my_customized_form_name
  end

  class I18nScopeForm < SuperForm::Basic
    form_name :customized_form_name
    i18n_prefix :customized_i18n_prefix
    attribute :title
  end

  module My
    class Form < SuperForm::Basic
    end
  end

  class Row
  end

  class SampleForm < SuperForm::Basic

    attribute :no_type_prop
    attribute :name, String
    attribute :default_name, String, default: "default_name"

    attribute :age, Integer
    attribute :default_age, Integer, default: 18

    attribute :ids, Array[Integer]
    attribute :default_ids, Array[Integer], default: [1, 2, 3]

    attribute :row, Row

    validates :name, presence: true

    def save
      validate
    end
  end

  before do
    @params = ActionController::Parameters.new({}).permit()
  end

  describe "form_name" do

    should "have default model_name" do
      form = EmptyForm.new @params
      assert_equal form.model_name, "EmptyForm"
    end

    should "have set form_name" do
      form = FormWithFormName.new @params
      assert_equal form.model_name, "MyCustomizedFormName"
    end
  end

  describe "i18n_scope" do

    # https://github.com/rails/rails/blob/v6.1.6/activemodel/lib/active_model/error.rb#L38
    should "have default i18n_scope" do
      form = EmptyForm.new @params
      assert_equal form.class.i18n_scope, :forms
      assert_equal form.model_name.i18n_key, :empty_form
    end

    should "be able to set i18n_scope" do
      form = I18nScopeForm.new @params
      assert_equal form.class.i18n_scope, :customized_i18n_prefix
      assert_equal form.model_name.i18n_key, :customized_form_name
    end
  end

  describe "active_model_name_for" do

    # https://github.com/rails/rails/blob/v6.1.6/activemodel/lib/active_model/naming.rb#L164
    # SuperForm::Basic 的 active_model_name_for 把 namespace 強制設定成 nil
    should "leave namespace untouched" do
      form = My::Form.new @params
      assert_equal form.model_name.param_key, "my_form"
    end
  end

  describe "validation" do
    params = ActionController::Parameters.new({}).permit()
    form = SampleForm.new params
    form.save
    # TODO: add sqlite
  end

end
