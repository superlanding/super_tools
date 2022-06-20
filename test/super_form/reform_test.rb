require "test_helper"
require "action_controller"

describe "SuperForm::ReformTest" do

  class EmptyReform < SuperForm::Reform
  end

  class I18nPrefixReform < SuperForm::Reform
    i18n_prefix :wow_prefix
  end

  before do
    @params = ActionController::Parameters.new({}).permit()
  end

  describe "form_name" do

    should "have default i18n_scope" do
      form = EmptyReform.new @params
      assert_equal form.class.i18n_scope, :activerecord
    end

    should "have set i18n_scope" do
      form = I18nPrefixReform.new @params
      assert_equal form.class.i18n_scope, :wow_prefix
    end
  end

end
