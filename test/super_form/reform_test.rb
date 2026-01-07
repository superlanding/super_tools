require "test_helper"
require "action_controller"

class SuperFormReformTest < Minitest::Spec

  class EmptyForm < SuperForm::Reform
  end

  class PrefixForm < SuperForm::Reform
    i18n_prefix :wow_prefix
  end

  class NamedForm < SuperForm::Reform
    form_name :one_ok_form
  end

  # https://trailblazer.to/2.0/gems/reform/rails.html#activemodel-compliance
  # SuperForm::Reform 的 extend ::ActiveModel::Translation
  # 把 Reform::Form::ActiveModel 的 model_name 蓋掉了
  # 所以底下的測試 model_name 不會被改到
  #
  # 但是如果是透過 validate 等相關函式觸發的 reform-rails model_name
  # 底下的 model 設定還是不會有效果
  # 因為吃不到 model 設定的 self.model_options
  # 詳情請參考
  # https://github.com/trailblazer/reform-rails/blob/v0.2.3/lib/reform/form/active_model/validations.rb
  class ModelNamedForm < SuperForm::Reform
    model :ok
    property :name
    validates :name, presence: true
    def save(params = {})
      validate params
    end
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
      form = ModelNamedForm.new Book.new
      form.save
      assert_equal form.model_name.to_s, "SuperFormReformTest::ModelNamedForm"

      # 吃不到 model 設定的 self.model_options
      names = form.class.lookup_ancestors.map { |klass| klass.model_name.to_s }
      assert_equal names, ["SuperFormReformTest::ModelNamedForm", "SuperForm::Reform", "Reform"]

      # 透過 form_name 再改掉 form.model_name
      form.class.form_name :huh
      names = form.class.lookup_ancestors.map { |klass| klass.model_name.to_s }
      assert_equal names, ["Huh", "SuperForm::Reform", "Reform"]
    end
  end

end
