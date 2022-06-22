require "test_helper"

class SuperProcessCoreTest < MiniTest::Spec

  class BookCover < SuperProcess::Core
    init :book do
      attribute :heading, String
    end
    attribute :subheading, String
    attribute :logs, Array

    validate :validate_book_name

    before_call :before_call

    callable do
      logs.push :callable
    end

    def before_call
      logs.push :before_call
    end

    def after_call
      logs.push :after_call
    end

    def before_task
      logs.push :before_task
    end

    def after_task
      logs.push :after_task
    end

    def validate_book_name
      # 不可以髒髒
      errors.add(:name, "Invalid book name") if book.name.include?("Shit")
    end
  end

  before do
    @book = Book.new(name: "Shitcode in a nutshell")
    @cover = BookCover.new(@book).tap do |cover|
      cover.logs = []
    end
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

  describe "callable" do

    should "be blocked by invalid book name" do
      assert_raises SuperProcess::Core::ValidError do
        @cover.call!
      end
      # validation 沒過，所以只有 :before_call
      assert_equal @cover.logs, [:before_call]
    end

  end
end
