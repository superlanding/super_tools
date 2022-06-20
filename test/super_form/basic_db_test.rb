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

    validates :name, presence: true

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

  describe "validation" do

    should "invalid" do
      params = create_params
      form = SampleForm.new params
      assert form.save == false
    end
  end

  after do
    clear_db
  end
end
