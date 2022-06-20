require "test_helper"
require "action_controller"

describe "SuperForm::BasicDbTest" do

  include DbHelper

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

    attribute :created_at, DateTime

    def save
      ActiveRecord::Base.transaction do
        valid?
      end
    end
  end

  def create_params(h = {})
    ActionController::Parameters.new(h).permit(h.keys)
  end

  before do
    init_db
  end

  describe "virtus" do

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

  describe "validation" do

    should "be invalid" do
      params = create_params
      form = SampleForm.new params
      assert form.save == false
    end

    should "be valid" do
      params = create_params(name: '1337')
      form = SampleForm.new params
      assert form.save
    end
  end

  after do
    clear_db
  end
end
