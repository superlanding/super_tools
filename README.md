# SuperTools

[![Gem Version](https://badge.fury.io/rb/super_tools.svg)](https://rubygems.org/gems/super_tools)
[![Test](https://github.com/superlanding/super_tools/actions/workflows/test.yml/badge.svg)](https://github.com/superlanding/super_tools/actions/workflows/test.yml)

SuperTools 是 Super Landing 內部 Rails 專案共用的工具箱，把各專案重複出現的小零件收在同一個 gem：

| 模組 | 用途 |
| --- | --- |
| [`SuperProcess`](#superprocess) | 單一用途的 Service Object（參數 → 驗證 → callback → 執行），以及「像類別方法一樣呼叫實例方法」的 `Basic` |
| [`SuperForm`](#superform) | Form Object：`Basic`（ActiveModel + Virtus）與 `Reform`（Reform + 交易式儲存 `AtomicSave`） |
| [`SuperValue`](#supervalue) | 包裝一個 model 的 Value Object（委派屬性 + init callback） |
| [`SuperSpreadsheet`](#superspreadsheet) | 讀取 `.csv`（UTF-8 / Big5 / Big5-HKSCS）、`.xls`、`.xlsx` 成二維陣列 |
| [`SuperFormatter`](#superformatter) | 把物流 / 電商匯出的表格（Ecan、Tcat、Hct、Shopline）轉成有欄位名稱的 row |
| [`SuperTable`](#supertable) | 在 view 裡用 Ruby 產生 Bootstrap 風格的 `<table>` |
| [`SuperZipcode`](#superzipcode) | 台灣地址 → 郵遞區號 |
| [`SuperSearch`](#supersearch) | 以 Searchkick / Elasticsearch scroll API 遍歷大量搜尋結果 |
| [`SuperInteraction`](#superinteraction) | 在 controller 組合要回傳給瀏覽器執行的 JS（alert、modal、reload…） |

## 需求

本 gem 必須在 Rails 環境中使用（`require "super_tools"` 時需要 `Rails` 已經載入；Rails app 透過 Bundler 載入即可）。

- Ruby `>= 2.7.0`
- Rails `>= 6.1, < 8.2`

CI（[`.github/workflows/test.yml`](.github/workflows/test.yml)）實際測試的組合：

| Ruby | Rails |
| --- | --- |
| 2.7.6 | 6.1、7.0 |
| 3.0.7 | 6.1、7.0 |
| 3.1.7 | 6.1、7.0 |
| 3.3.12 | 8.0、8.1 |
| 3.4.11 | 8.0、8.1 |

## 安裝

```ruby
# Gemfile
gem "super_tools"
```

```bash
bundle install
```

要使用 `SuperForm::Reform` 的巢狀表單驗證時，本專案自己的 Gemfile 使用的是 fork 版 `reform-rails`（修正無限迴圈問題，測試也是對著這個 fork 跑的）：

```ruby
gem "reform-rails", github: "superlanding/reform-rails", tag: "v0.2.6.f"
```

gemspec 對 `reform-rails` 沒有版本限制，所以消費端是否一定要用 fork 取決於你的表單用法；上面這行是本專案測試使用的設定。

> `super_tools` 會一併安裝 `reform` 2.6.2、`dry-types` 1.5.1、`dry-logic` 1.2.0、`virtus`、`roo`、`roo-xls`、`spreadsheet`、`fast_excel`、`searchkick`、`warehouse_items` 等相依（精確版本見 [`super_tools.gemspec`](super_tools.gemspec)）。

## 設定

大部分模組不需要設定。需要時才設定的有兩個：

**1. SuperTable 需要 Rails URL helper 時**，在 `config/initializers/super_table.rb` 自行混入：

```ruby
SuperTable::Builder.send(:include, ::Rails.application.routes.url_helpers)
SuperTable::Record.send(:include, ::Rails.application.routes.url_helpers)
SuperTable::Tableable.send(:include, ::Rails.application.routes.url_helpers)
```

**2. SuperInteraction 的 `js.modal`** 需要先指定 modal layout 使用的前端框架（沒設定會因為 `@@framework` 未初始化而丟 `NameError`），支援 `:bootstrap3`、`:bootstrap4`、`:beyond`：

```ruby
# config/initializers/super_interaction.rb
SuperInteraction::Layout.framework = :bootstrap4
```

## 使用方式

以下範例都在本專案的測試環境（Ruby 3.4 / Rails 8.1）實際執行過；範例裡的 `Book` 是只有 `name` 欄位的 ActiveRecord model。

### SuperProcess

#### `SuperProcess::Core`

Service Object：`init` 宣告要處理的 model，`attribute`（Virtus）宣告輸入參數並自動轉型，驗證用 ActiveModel 的 `validates` / `validate`，`callable` 區塊是真正的工作。

```ruby
class PublishBook < SuperProcess::Core
  init :book

  attribute :name, String
  attribute :price, Integer

  validates :name, presence: true
  validate :price_must_not_be_negative

  before_call :prepare            # 另有 after_call / before_task / after_task

  callable do
    book.update!(name: name)
    book                          # 回傳值會放在 #result
  end

  def prepare
    # ...
  end

  def price_must_not_be_negative
    errors.add(:price, "不可小於 0") if price.to_i < 0
  end
end

service = PublishBook.new(Book.new)
service.call(name: "Ruby", price: "100")  #=> true
service.price                              #=> 100（字串被轉成 Integer）
service.result                             #=> #<Book ...>
service.error_messages                     #=> []

service = PublishBook.new(Book.new)
service.call(name: "", price: -1)          #=> false（驗證失敗，不會執行 callable）
service.error_message                      #=> "can't be blank"（第一筆錯誤）
service.error_messages                     #=> ["can't be blank", "不可小於 0"]（Array）

service.call!(name: "")                    # 驗證失敗時丟 SuperProcess::Core::ValidError
```

執行順序：`before_call` → 驗證 → `before_task` → `callable` → `after_task` → `after_call`。

#### `SuperProcess::Basic`

讓類別可以直接呼叫實例方法（透過 `method_missing` 先 `new` 再呼叫）：

```ruby
class Robot
  extend SuperProcess::Basic

  def hello
    "hi"
  end
end

Robot.hello #=> "hi"
Robot.not_defined #=> NoMethodError
```

### SuperForm

#### `SuperForm::Basic`

ActiveModel + Virtus 的表單物件，適合不對應資料表的表單。`form_name` 決定 `model_name`（給 `form_for` 用），`i18n_prefix` 決定 i18n scope（預設 `:forms`）。

```ruby
class ContactForm < SuperForm::Basic
  form_name :contact
  attribute :email, String
  attribute :age, Integer
  validates :email, presence: true
end

form = ContactForm.new(email: "", age: "20")
form.valid?                #=> false
form.errors.full_messages  #=> ["Email can't be blank"]
form.age                   #=> 20
form.model_name.to_s       #=> "Contact"
ContactForm.i18n_scope     #=> :forms
```

#### `SuperForm::Reform`

繼承 `Reform::Form`，加上 `form_name` / `i18n_prefix`（預設 `:activerecord`）、型別轉換（Coercion），以及 `SuperForm::AtomicSave` 提供的 `save_with_transaction`：驗證、同步到 model、執行你的區塊、`save!` 全部包在同一個資料庫交易裡。

```ruby
class BookForm < SuperForm::Reform
  form_name :book
  property :name
  validates :name, presence: true

  before_commit { Rails.logger.info("before_commit") }
  after_commit  { Rails.logger.info("after_commit") }

  def save(params = {})
    save_with_transaction(params) do
      model.status = "selling"   # 在 sync 之後、save! 之前執行的區塊
    end
  end
end

form = BookForm.new(Book.new)
form.save(name: "")      #=> false（驗證失敗，交易 rollback）
form.errors.full_messages #=> ["Name can't be blank"]

form = BookForm.new(Book.new)
form.save(name: "Ruby")  #=> true
form.model.persisted?    #=> true

form.save_with_transaction!(name: "") # 驗證失敗時丟 SuperForm::AtomicSave::ReformAtomicSaveError
```

可用的 callback：`before_transaction`、`before_queries`、`before_validations`、`after_validations`、`before_commit`、`after_commit`；每個都可以傳方法名稱或區塊（兩者擇一）。巢狀 collection 的寫法請參考 [`test/super_form/reform_db_test.rb`](test/super_form/reform_db_test.rb)。

### SuperValue

```ruby
class OrderValue < SuperValue::Base
  init :order            # 建構時傳入的 model
  property :title        # 委派給 order.title
  after_init { @label = "#{title}!" }   # 另有 before_init
  attr_reader :label
end

value = OrderValue.new(Struct.new(:title).new("x"))
value.title #=> "x"
value.label #=> "x!"
```

### SuperSpreadsheet

`SuperSpreadsheet::Loader` 繼承 `SuperProcess::Core`，依副檔名讀取 `.csv`（依序嘗試 Big5、Big5-HKSCS，最後當 UTF-8）、`.xls`、`.xlsx`，浮點數若是整數會轉成 Integer。

```ruby
loader = SuperSpreadsheet::Loader.new("/tmp/orders.csv").tap(&:call)
loader.result
#=> [["姓名", "電話"], ["許功蓋", "0912-333-456"]]

bad = SuperSpreadsheet::Loader.new("/tmp/file.lol")
bad.call            #=> false
bad.error_messages  #=> ["檔案格式錯誤"]（空白檔案則是「檔案內容錯誤，空白檔案」）
```

### SuperFormatter

把 `SuperSpreadsheet::Loader` 讀進來的表格，依第一列標題找出欄位，轉成可以用欄位名稱存取的 row。目前有 `Ecan`、`Tcat`、`Hct`、`Shopline`：

```ruby
spreadsheet = SuperSpreadsheet::Loader.new("tcat_export.csv").tap(&:call)
import = SuperFormatter::Tcat::Import.new(spreadsheet).tap(&:call)

row = import.result.first
row.global_order_id #=> "MB40881"
row.recipient       #=> "黃齡萱"
row.mobile          #=> "0977481414"
row.tracking_code   #=> "625270211891"
```

`SuperFormatter::Shopline::Import` 會把同一張訂單的多列商品合併，`result` 是 `SuperFormatter::Shopline::Order` 陣列（`rows` 是原始每一列）：

```ruby
spreadsheet = SuperSpreadsheet::Loader.load!("shopline_export.xls").tap(&:call)
import = SuperFormatter::Shopline::Import.new(spreadsheet)
import.call          #=> true
import.result.first  #=> #<SuperFormatter::Shopline::Order ...>
```

各家欄位對應表在 `lib/super_formatter/*/head.rb`；新增一家物流時，照 `Tcat` 的 `Head` / `Row` / `Import` 三個檔案的做法，並在 `lib/super_tools.rb` 加上 `require`。

### SuperTable

用 Ruby 宣告表格欄位，再在 view 裡渲染。`column` 宣告欄位（key、標題、HTML 屬性，`desc:` 會顯示在標題下方的小字），`collection` 宣告資料集合與每筆資料的呈現方式（`property` 委派給 model，其餘方法可自行覆寫），`placeholder` 是沒有資料時顯示的內容。

```ruby
class OrdersTable < SuperTable::Tableable
  column :ship_no, "訂單編號", width: 100
  column :recipient, "收件人", desc: "姓名 / 電話"
  column :amount, "金額", class: "text-end"

  collection :orders do
    property :ship_no
    def amount_text
      "NT$ #{model.amount}"
    end
  end

  def placeholder
    "目前沒有訂單"
  end
end
```

```erb
<%# controller 裡：@table = OrdersTable.new(orders) %>
<%= super_table(@table, size: :sm, responsive: :md) do |t| %>
  <%= t.heads :ship_no, :recipient, :amount %>
  <%= t.columns do |order| %>
    <%= t.column :ship_no %>
    <%= t.column order.recipient %>
    <%= t.column order.amount_text, class: "text-end" %>
  <% end %>
<% end %>
```

輸出（有兩筆資料時，已省略換行）：

```html
<div class="table-responsive-md"><table class="table table-hover table-sm"><tr class="table-secondary"><th width="100">訂單編號</th><th>收件人<div class="small text-primary">姓名 / 電話</div></th><th class="text-end">金額</th></tr><tr><td>A1</td><td>王小明</td><td class="text-end">NT$ 100</td></tr>…</table></div>
```

`super_table` 的選項：`hover:`（預設 `true`，且只有在有資料時才加 `table-hover`）、`size: :sm`、`responsive: :sm / :md / :lg / :xl`，其餘選項會變成 `<table>` 的 HTML 屬性。沒有資料時 `t.columns` 會輸出一列 `placeholder`（沒定義就顯示「尚無資料」）。

### SuperZipcode

```ruby
SuperZipcode::Taiwan.find_zip_code("高雄市鳳山區鳳甲一街129號")
#=> "830"（字串）
```

### SuperSearch

`SuperSearch::Scroll` 包裝 Searchkick 的查詢，改用 Elasticsearch scroll API 分批遍歷（單批最多 10000 筆）。需要可連線的 Elasticsearch，本專案測試沒有涵蓋這個模組。

```ruby
scroll = SuperSearch::Scroll.new(Member, term: "*", options: { where: { age: 20 }, scroll: "5m", size: 1000 })
scroll.search do |results, total_count|
  results.each { |member| ... }
end
```

### SuperInteraction

在 controller 組合要回傳給瀏覽器執行的 JavaScript，`run` 會以 `render js:` 回傳。需要前端有 jQuery 外掛（`$.modal`、`$.alert`，Beyond 版是 `$.uniqModal`）與 Turbolinks，modal layout 使用 HAML（App 需自行安裝 `haml`）。本專案測試沒有涵蓋這個模組。

```ruby
class ApplicationController < ActionController::Base
  include SuperInteraction::BootstrapHelper  # 提供 js  （Bootstrap 版）
  include SuperInteraction::BeyondHelper     # 提供 srj（Beyond 版）
end

class MembersController < ApplicationController
  def index
    js.alert("Hello world").reload.run
  end

  def new
    @member = Member.new
    # View: app/views/members/edit.html.haml
    # Layout: 依 SuperInteraction::Layout.framework 選擇內建的 modal layout
    js.modal(partial: :edit, size: "lg", title: "新增會員").run
  end
end
```

可串接的方法：`alert`、`modal`、`close`、`reload`、`redirect_to(url)`、`ajax_get(url)`、`modal_saved_reload(message)`、`modal_saved_rediret_to(message, url)`、`cmd(js_code)`；通知用 `bs_notice` / `bs_danger` / `bs_success`（Beyond 版是 `b_notice` / `b_danger` / `b_success`）。

## 開發與測試

```bash
git clone git@github.com:superlanding/super_tools.git
cd super_tools

# 選一個 gemfiles/ 底下的組合（命名：ruby_<版本>_rails_<版本>.gemfile）
export BUNDLE_GEMFILE=$PWD/gemfiles/ruby_3.4_rails_8.1.gemfile
bundle install
bundle exec rake t        # 跑 test/**/*_test.rb
```

- 測試框架是 Minitest + shoulda-context，測試資料在 `test/support/`。
- 想一次跑 Ruby 2.7 / 3.0 / 3.1 × Rails 6 / 7，可用 `bin/test_all`（Appraisal）；以 `gemfiles/` 與 `.github/workflows/test.yml` 為準，[`MULTI_RUBY_TESTING.md`](MULTI_RUBY_TESTING.md) 只描述 Rails 6 / 7 的組合。
- 專案的 Gemfile 會從 GitHub 安裝 fork 版 `reform-rails`，需要能連到 GitHub。

## 發版

本 gem 透過 GitHub Actions（[`.github/workflows/publish.yml`](.github/workflows/publish.yml)）以 RubyGems Trusted Publishing 自動發佈，不使用 API key：

1. 開 PR 時修改 `lib/super_tools/version.rb`（Semantic Versioning：修 bug 跳 patch、相容的新功能跳 minor、不相容變更跳 major）。
2. 同一個 PR 更新 [CHANGELOG.md](CHANGELOG.md)（新增 `## [x.y.z] - YYYY-MM-DD` 區塊）與必要的 README.md。
3. CI 通過、由真人合併到 `master`。
4. `publish.yml` 發現 `master` 的版本號還不在 rubygems.org 時，會先跑測試（Ruby 3.4 / Rails 8.1），再發佈並打上 `vX.Y.Z` tag；版本已存在則自動略過。

只改文件 / CI / CLAUDE.md 的 PR 可以不跳版號（合併後不會發佈）。

## 參與開發

每個 PR 都要同步更新 README.md（行為、用法、設定、相依或支援版本有變動時）與 CHANGELOG.md，規則寫在 [CLAUDE.md](CLAUDE.md)。

## 授權

[MIT License](LICENSE.txt)
