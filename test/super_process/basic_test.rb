require "test_helper"

class SuperProcessBasicTest < Minitest::Spec

  class Robot
    extend SuperProcess::Basic

    def i_am_instance_method
      "called"
    end
  end

  describe "method_missing" do

    should "call like a static method" do
      assert_equal Robot.i_am_instance_method, "called"
    end

    should "raise error" do
      assert_raises NoMethodError do
        Robot.method_does_not_exsit
      end
    end
  end

end
