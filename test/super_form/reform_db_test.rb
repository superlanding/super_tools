require "test_helper"
require "action_controller"

class SuperFormReformDbTest < ActiveSupport::TestCase

  class SampleForm < SuperForm::Reform
    form_name :sample_form
    model :book
    property :name
    validates :name, presence: true

    def save(params = {})
      save_with_transaction(params) do
      end
    end
  end

  class AnotherForm < SuperForm::Reform
    i18n_prefix :another_prefix
    form_name :another_form
    model :book
    property :name
    validates :name, presence: true

    def save(params = {})
      save_with_transaction(params) do
      end
    end
  end


  def create_params(h = {})
    ActionController::Parameters.new(h).permit(h.keys)
  end

  context "Error messages" do

    setup do
      I18n.locale = :en
    end

    should "be able to use default i18n prefix" do
      form = SampleForm.new Book.new
      form.save
      assert_equal form.errors[:name].first, "can't be blank"

      # 切換語言後要重新呼叫 save_with_transaction 才會更新錯誤訊息的語言
      I18n.locale = :"zh-TW"
      form.save
      assert_equal form.errors[:name].first, "書名不可以空白"
    end

    should "set i18n prefix" do
      I18n.locale = :"zh-TW"
      form = AnotherForm.new Book.new
      form.save
      assert_equal form.errors[:name].first, "書名不可以空白，請填寫書名"
    end
  end

end
