require "test_helper"

class SuperZipcodeTaiwanTest < MiniTest::Spec

  describe "find_zip_code" do

    should "handle invalid address" do
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

end
