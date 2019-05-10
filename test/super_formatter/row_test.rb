require 'test_helper'

describe "SuperFormatter::Row" do
  before do
    data = [ 'a', 'b' ]
    indexes = {:a => 0, :b => 1, :c => 3}
    @row = SuperFormatter::Row.new(data, indexes)
  end

  should "#a = a" do
    assert_equal 'a', @row.a
  end

  should "#b = b" do
    assert_equal 'b', @row.b
  end

  should "#c = nil" do
    assert_nil @row.c
  end

  should "#complete? = false" do
    assert_equal false, @row.complete?
  end
end
