require "test_helper"

class SuperProcessCoreTest < MiniTest::Spec

  class BookCover < SuperProcess::Core
    init :book do
      attribute :heading, String
    end
    attribute :subheading, String
  end

  before do
    @book = Book.new(name: "Shitcode in a nutshell")
    @cover = BookCover.new @book
  end

  describe "init" do
    should "set model_name to attr_accessor and run block" do
      assert_equal @cover.book, @book
      assert @cover.respond_to? :book=

      assert @cover.respond_to? :heading
      assert @cover.respond_to? :heading=

      assert @cover.respond_to? :subheading
      assert @cover.respond_to? :subheading=
    end
  end

end
