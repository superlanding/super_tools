require "test_helper"

class SuperZipcodeTaiwanTest < Minitest::Spec

  describe "find_zip_code" do

    should "handle invalid address" do
      assert_nil SuperZipcode::Taiwan.find_zip_code("")
      assert_nil SuperZipcode::Taiwan.find_zip_code("亂打地址")
      assert_nil SuperZipcode::Taiwan.find_zip_code("台北市天龍區")
    end

    SuperZipcode::Taiwan::CITY_ZONE_ZIP_CODES.each do |city, district_hash|
      district_hash.each do |district, code|
        address = "#{city}#{district}"
        should "handle address: #{address}" do
          assert_equal SuperZipcode::Taiwan.find_zip_code(address), code
        end
      end
    end

  end

  describe "find_city" do

    should "handle invalid address" do
      assert_nil SuperZipcode::Taiwan.find_city("")
      assert_nil SuperZipcode::Taiwan.find_city("台北國")
      assert_nil SuperZipcode::Taiwan.find_city("I don't know where it is")
    end

    SuperZipcode::Taiwan::CITY_ZONE_ZIP_CODES.each do |city, _|
      address = "#{city}東沙群島"
      should "handle valid address: #{address}" do
        assert_equal SuperZipcode::Taiwan.find_city(address), city
      end
    end
  end

end
