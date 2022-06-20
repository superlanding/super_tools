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

  before do
    @params = ActionController::Parameters.new({ title: "title" })
      .permit(:title)
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

    should "have be able to set i18n_scope" do
      form = I18nScopeForm.new @params
      assert_equal form.class.i18n_scope, :customized_i18n_prefix
      assert_equal form.model_name.i18n_key, :customized_form_name
    end
  end

end
