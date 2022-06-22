require "test_helper"

class SuperProcessCoreTest < MiniTest::Spec

  class BookCover < SuperProcess::Core
    init :book do
      attribute :heading, String
    end
  end

  describe "init" do
    should "set model_name to attr_accessor" do
      cover = BookCover.new Book.new(name: "Shitcode in a nutshell")
      assert cover.respond_to? :book
      assert cover.respond_to? :book=
    end
  end
end
