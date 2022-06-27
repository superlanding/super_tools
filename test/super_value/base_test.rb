require "test_helper"

describe "SuperTable::BaseTest" do

  Order = Struct.new(:id, :title)

  class Value < SuperValue::Base
    attr_accessor :data
    init :order
    property :id
    property :title

    after_init do
      self.data = "#{id}:#{title}"
    end
  end

  before do
    @order = Order.new(1, "Eddie")
    @value = Value.new(@order)
  end


  should "#id = 1" do
    assert_equal 1, @value.id
  end

  should "#title = Eddie" do
    assert_equal "Eddie", @value.title
  end

  should "#order = @order" do
    assert_equal @order, @value.order
  end

  should "#data = 1:Eddie" do
    assert_equal "1:Eddie", @value.data
  end
end
