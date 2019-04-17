# SuperForm::Reform

```ruby
class MerchantForm::Edit < SuperForm::Reform
  model :merchant

  property :title, default: ''
  property :contact, default: ''
end

```

# SuperLogger::Formatter

就是之前的 `LoggerFormatter`

# SuperProcess::Core

```ruby
class BillingCalculate < SuperProcess::Core
  init :billing do
    attribute :total_orders_amount, Integer
  end

  callable do
    "RESULT_OBJECT"
  end

  def valid_amount
    if total_orders_amount > 1000
      errors.add(:total_orders_amount, "金額必須小於 1000 元")
    end
  end
end

@service = BillingCalculate.new(@billing)
@service.call(total_orders_amount: "100")
#=> true
@service.total_orders_amount 
#=> 100
@service.result 
#=> "RESULT_OBJECT"
@service.error_messages
#=> ""
```

# SuperZipcode::Taiwan

```ruby
SuperZipcode::Taiwan.find_zip_code("高雄市鳳山區鳳甲一街129號")
#=> 830
```

# SuperTable

如需要 Rails URL helper 請於 initializers/suepr_table.rb 自行混入

```ruby
SuperTable::Builder.send(:include, ::Rails.application.routes.url_helpers)
SuperTable::Record.send(:include, ::Rails.application.routes.url_helpers)
SuperTable::Tableable.send(:include, ::Rails.application.routes.url_helpers)
```

# SuperSpreadsheet::Loader

```ruby
@spreadsheet = SuperSpreadsheet::Loader.new("/tmp/xxx.csv").tap { |s| s.call }
@spreadsheet = SuperSpreadsheet::Loader.new("/tmp/xxx.xls").tap { |s| s.call }
@spreadsheet = SuperSpreadsheet::Loader.new("/tmp/xxx.xlsx").tap { |s| s.call }

@spreadsheet.result
#=> [ [ '欄位1', '欄位2', '欄位3' ], [ '資料1', '資料2', '資料3'] ]
```

# SuperSearch::Scroll

```ruby
::SuperSearch::Scroll.new(Member, options: { where: { age: 20 } })
```

# SuperInteraction

### app/controllers/application_controller.rb

```ruby
class ApplicationController < ActionController::Base
  include SuperInteraction::ControllerHelper
end
```

### app/controllers/members_controller.rb

```ruby
class MembersController < ApplicationController
  # GET /
  def index
    js.alert("Helloworld").reload.run
  end

  # GET /
  def new
    @member = Member.new
    # View: app/views/members/edit.html.haml
    # Layout: app/views/layouts/modal.html.haml
    js.modal(partial: :edit).run
  end
end
```

### app/views/layouts/modal.html.haml

```haml
.modal
  = yield :wrapper
  .modal-dialog{ class: "modal-#{bs_modal_size}" }
    .modal-content
      .modal-header
        %button.close{"aria-label" => "Close", "data-dismiss" => "modal", :type => "button"}
          = fa_icon('times')
        = yield :header
        - if title.present?
          %h4.modal-title= title
      = yield
      = yield :before_body
      - body_html = capture { yield :body }
      - if body_html.present?
        .modal-body= body_html
      = yield :after_body

      - footer_html = capture { yield :footer }
      - if footer_html.present?
        .modal-footer= footer_html

```
