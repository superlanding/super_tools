ActiveRecord::Schema.define(version: 1) do

  create_table "books" do |t|
    t.string "name"
    t.string "content"
    t.string "status"
  end

  create_table "fake_books" do |t|
    t.integer "page", default: 0, null: false
  end

end
