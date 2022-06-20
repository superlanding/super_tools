require "test_helper"
require "action_controller"

describe "SuperForm::BasicTest" do

  before do
    @params = ActionController::Parameters.new({ one: 'one', two: 'two' })
      .permit(:one, :two)
  end

  describe "form_name" do

    should "have default model_name" do
      class EmptyForm < SuperForm::Basic
      end
      form = EmptyForm.new @params
      assert_equal(form.model_name, 'EmptyForm')
    end

    should "have set form_name" do
      class FormWithFormName < SuperForm::Basic
        form_name :my_customized_form_name
      end
      form = FormWithFormName.new @params
      assert_equal(form.model_name, 'MyCustomizedFormName')
    end
  end

end
