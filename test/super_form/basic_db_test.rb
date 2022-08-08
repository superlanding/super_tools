require "test_helper"
require "action_controller"

class SuperFormBasicDbTest < ActiveSupport::TestCase

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

    validates :name, presence: true, length: { minimum: 3 }
    validates :age, presence: true, numericality: { greater_than_or_equal_to: 18 }

    attribute :created_at, DateTime

    def save
      ActiveRecord::Base.transaction do
        valid?
      end
    end
  end

  class AdminBasicForm < SuperForm::Basic
    i18n_prefix :admin
    attribute :name, String
    validates :name, presence: true
    def save
      valid?
    end
  end

  class BookForm < SuperForm::Basic
    attribute :name, String
    validates :name, presence: true

    def save
      ActiveRecord::Base.transaction do
        return false unless valid?
        Book.create attributes
      end
    end
  end

  def create_params(h = {})
    ActionController::Parameters.new(h).permit(h.keys)
  end

  setup do
    I18n.locale = :en
  end

  context "virtus" do

    should "have attributes" do
      form = SampleForm.new create_params
      assert_equal(
        form.attributes.keys,
        [:no_type_prop, :name, :default_name, :age, :default_age, :ids, :default_ids, :row, :created_at]
      )
    end

    should "have default values" do
      form = SampleForm.new create_params
      assert_equal form.default_name, "default_name"
      assert_equal form.default_age, 18
      assert_equal form.default_ids, [1, 2, 3]
    end

    should "be able to assign values" do
      form = SampleForm.new create_params
      form.name = "Macdella"
      form.age = "26"
      form.created_at = "June 20th, 2022"

      assert_equal form.name, "Macdella"
      assert_equal form.age, 26
      assert_equal form.created_at, DateTime.new(2022, 6, 20)
    end

    should "be able to reset attributes" do
      form = SampleForm.new create_params
      assert_equal form.default_name, "default_name"

      form.default_name = "changed"
      assert_equal form.default_name, "changed"

      form.reset_attribute(:default_name)
      assert_equal form.default_name, "default_name"
    end

  end

  context "validation" do

    should "be invalid" do
      params = create_params
      form = SampleForm.new params
      assert form.save == false
    end

    should "be valid" do
      params = create_params(name: '1337', age: 18)
      form = SampleForm.new params
      assert form.save
    end
  end

  context "i18n error messages" do

    # https://github.com/rails/rails/blob/v6.1.6/activemodel/lib/active_model/error.rb#L80
    should "default i18n_scope: forms" do
      params = create_params(age: 17)
      form = SampleForm.new params
      form.save

      # Rails 預設
      assert_equal form.errors[:name].first, "can't be blank"

      # locales/en.yml 有設定
      assert_equal form.errors[:age].first, "The cop is waiting for you"

      I18n.locale = :"zh-TW"
      assert_equal form.errors[:age].first, "警察北北在等你"
    end

    should "set i18n_scope: admin" do
      form = AdminBasicForm.new create_params
      form.save

      assert_equal form.errors[:name].first, "can't be blank"

      I18n.locale = :"zh-TW"
      assert_equal form.errors[:name].first, "名字要填喔"
    end
  end

  context "save behavior" do

    should "be able to create" do
      params = create_params(name: "小王子")
      form = BookForm.new params
      form.save
      assert_equal Book.all.size, 1
    end

    should "not be able to create" do
      params = create_params
      form = BookForm.new params
      form.save
      assert_equal Book.all.size, 0
    end
  end

end
