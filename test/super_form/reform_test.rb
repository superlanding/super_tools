require "test_helper"
require "action_controller"

class SuperFormReformTest < MiniTest::Spec

  class EmptyForm < SuperForm::Reform
  end

  class PrefixForm < SuperForm::Reform
    i18n_prefix :wow_prefix
  end

  class ReformWithFormName < SuperForm::Reform
    form_name :one_ok_form
  end

  before do
    @params = ActionController::Parameters.new({}).permit()
  end

  describe "i18n_prefix" do

    should "have default i18n_scope" do
      form = EmptyForm.new @params
      assert_equal form.class.i18n_scope, :activerecord
    end

    should "have set i18n_scope" do
      form = PrefixForm.new @params
      assert_equal form.class.i18n_scope, :wow_prefix
      assert_equal form.class.model_name.i18n_key, :"super_form_reform_test/prefix_form"
    end
  end

  describe "form_name" do

    should "have default model_name" do
      form = EmptyForm.new @params
      assert_equal form.class.model_name.to_s, "SuperFormReformTest::EmptyForm"
    end

    should "have set form_name" do
      form = ReformWithFormName.new @params
      assert_equal form.class.model_name.to_s, "OneOkForm"
    end
  end

end
