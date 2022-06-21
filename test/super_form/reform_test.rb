require "test_helper"
require "action_controller"

class SuperFormReformTest < MiniTest::Spec

  class EmptyForm < SuperForm::Reform
  end

  class PrefixForm < SuperForm::Reform
    i18n_prefix :wow_prefix
  end

  class NamedForm < SuperForm::Reform
    form_name :one_ok_form
  end

  # https://trailblazer.to/2.0/gems/reform/rails.html#activemodel-compliance
  # 根據官網的做法應該是要在 SuperForm::Reform
  # include Reform::Form::ActiveModel，使用 model 才會有效果
  # 所以底下的測試 model_name 不會被改到
  class ModelNamedForm < SuperForm::Reform
    include Reform::Form::ActiveModel
    model :ok
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
      form = NamedForm.new @params
      assert_equal form.class.model_name.to_s, "OneOkForm"
    end
  end

  describe "model" do
    should "have no effect at all" do
      form = ModelNamedForm.new @params
      assert_equal form.model_name.to_s, "SuperFormReformTest::ModelNamedForm"
    end
  end

end
