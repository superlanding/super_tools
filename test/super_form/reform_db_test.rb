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

  class MethodNameCallbackForm < SuperForm::Reform
    model :book
    attr_accessor :called

    before_transaction :before_transaction
    before_queries :before_queries
    before_validations :before_validations
    after_validations :after_validations
    before_commit :before_commit
    after_commit :after_commit

    def initialize(book)
      super book
      self.called = []
    end

    def before_transaction
      called.push :before_transaction
    end

    def before_queries
      called.push :before_queries
    end

    def before_validations
      called.push :before_validations
    end

    def after_validations
      called.push :after_validations
    end

    def before_commit
      called.push :before_commit
    end

    def after_commit
      called.push :after_commit
    end
  end

  class CallbackForm < SuperForm::Reform
    model :book
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

  context "Saving" do

    should "be able to save" do
      # 未新增
      assert_equal Book.all.size, 0

      # 新增
      form = SampleForm.new Book.new(name: "三民主義")
      form.save
      assert_equal Book.all.size, 1
      assert_equal Book.first.name, "三民主義"

      # 編輯
      form.save(name: "吾黨所宗")
      assert_equal Book.all.size, 1
      assert_equal Book.first.name, "吾黨所宗"
    end

    should "be able to validate" do
      # 沒給書名
      form = SampleForm.new Book.new
      form.save
      assert_equal Book.all.size, 0
      assert form.errors[:name].present?
    end
  end

  context "Callbacks" do

    should "call method_name callbacks" do
      form = MethodNameCallbackForm.new Book.new(name: "o_o")
      form.save_with_transaction
      expected = [ :before_transaction, :before_queries, :before_validations,
        :after_validations, :before_commit, :after_commit ]
      assert_equal form.called, expected
    end

    should "call block callback" do

      called = []

      CallbackForm.before_transaction do
        called.push :before_transaction
      end

      CallbackForm.before_queries do
        called.push :before_queries
      end

      CallbackForm.before_commit do
        called.push :before_commit
      end

      CallbackForm.after_commit do
        called.push :after_commit
      end

      CallbackForm.before_validations do
        called.push :before_validations
      end

      CallbackForm.after_validations do
        called.push :after_validations
      end

      form = CallbackForm.new Book.new(name: "ruby 圈: 不給我 merge ? 看我 monkey patch 你的 code")
      form.save_with_transaction

      # 有呼叫順序
      expected = [
        :before_transaction,
        :before_queries,
        :before_validations,
        :after_validations,
        :before_commit,
        :after_commit
      ]
      assert_equal called, expected
    end
  end

end
