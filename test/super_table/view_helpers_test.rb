require 'active_support/core_ext/string/strip'
require 'test_helper'

class SuperTableTest < SuperTable::Tableable
  column :ship_no, '訂單編號', width: 100, class: 'text-dark'
  column :recipient, '收件人', desc: '姓名 / 電話'

  collection :orders do
    def ship_no
      "訂單編號_#{model.ship_no}"
    end

    def recipient
      "李大同 #{content_tag(:small, '0972333333')}".html_safe
    end
  end

  def placeholder
    content_tag(:span) do
      concat "尚無訂單資料，前往"
      concat link_to "新增", '/orders/new'
      concat "?"
    end
  end
end

describe "SuperTable::ViewHelpersTest" do
  include BuildOrdersHelper
  
  def render(template)
    @lookup_context ||= ActionView::LookupContext.new(ActionController::Base.view_paths)
    @context ||= ActionView::Base.with_empty_template_cache.new(lookup_context, {}, nil)
    @view ||= ActionView::Base.new @lookup_context
    @view.render(@context, inline: template, locals: { table: @table }).gsub("\n", "")
  end
  
  before do
    @orders = build_orders
    @table = SuperTableTest.new(@orders)
  end

  should 'view_helper 應該要有 #super_table' do
    helper = ActionView::Base.new
    assert(helper.respond_to?(:super_table))
  end

  describe "#super_table" do
    should '預設值正確' do
      erb = "<%= super_table(table) %>"
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover"></table>
      HTML
      assert_equal(html, render(erb))
    end

    should '應該要有額外設定值' do
      erb = "<%= super_table(table, class: 'table-striped', size: :sm, hover: false) %>"
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-striped table-sm"></table>
      HTML
      assert_equal(html, render(erb))
    end

    should 'With block' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <tr>
        <td>test</td>
        </tr>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr>
        <td>test</td>
        </tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end
  end

  describe "#heads" do
    should '預設' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary"></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should "要能帶入 HTML options" do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads class: 'test' %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary test"></tr>
      </table>

      HTML
      assert_equal(html, render(erb))
    end

    should "應該要能 render 表頭" do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads :ship_no, :recipient %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary"><th width="100" class="text-dark">訂單編號</th><th>收件人<div class="small text-primary">姓名 / 電話</div></th></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end
  end

  describe '#head' do
    should '預設值正確' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads do %>
          <%= t.head :ship_no %>
          <%= t.head :recipient %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary">
          <th width="100" class="text-dark">訂單編號</th>
          <th>收件人<div class="small text-primary">姓名 / 電話</div></th></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should '可以適用 html options' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads do %>
          <%= t.head :ship_no, width: 90, class: 'text-primary' %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary">
          <th width="90" class="text-primary text-dark">訂單編號</th></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should '可以使用 "HTML 字串"' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads do %>
          <%= t.head content_tag(:span, '訂單編號123'), width: 90, class: 'text-primary' %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary">
          <th width="90" class="text-primary"><span>訂單編號123</span></th></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should '可以使用 block' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.heads do %>
          <%= t.head width: 90 do %>
            訂單編號123
          <% end %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr class="table-secondary">
          <th width="90">
            訂單編號123</th></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end
  end

  describe "#columns" do
    should '預設值' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr></tr><tr></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should 'With block' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns do %>
          <td>test</td>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr>
          <td>test</td></tr><tr>
          <td>test</td></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should '可迭代 record' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns do |order| %>
          <td><%= order.ship_no %></td>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr>
          <td>訂單編號_000108</td></tr><tr>
          <td>訂單編號_000107</td></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should "要能直接 render tbody" do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns :ship_no, :recipient %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr><td>訂單編號_000108</td><td>李大同 <small>0972333333</small></td></tr><tr><td>訂單編號_000107</td><td>李大同 <small>0972333333</small></td></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end
  end

  describe "#column" do
    should "預設值要正確" do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns do |order| %>
          <%= t.column :ship_no %>
          <%= t.column :recipient %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr>
          <td>訂單編號_000108</td>
          <td>李大同 <small>0972333333</small></td></tr><tr>
          <td>訂單編號_000107</td>
          <td>李大同 <small>0972333333</small></td></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should '可以適用 html options' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns do |order| %>
          <%= t.column :ship_no, class: 'text-center' %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr>
          <td class="text-center">訂單編號_000108</td></tr><tr>
          <td class="text-center">訂單編號_000107</td></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should '可傳入 HTML 字串' do
      erb = <<-ERB.strip_heredoc
      <%= super_table(table) do |t| %>
        <%= t.columns do |order| %>
          <%= t.column content_tag(:span, 'XXX'), class: 'text-center' %>
        <% end %>
      <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
      <table class="table table-hover">
        <tr>
          <td class=\"text-center\"><span>XXX</span></td></tr><tr>
          <td class=\"text-center\"><span>XXX</span></td></tr>
      </table>
      HTML
      assert_equal(html, render(erb))
    end

    should "可以使用 block" do
      erb = <<-ERB.strip_heredoc
        <%= super_table(table) do |t| %>
          <%= t.columns do |order| %>
            <%= t.column class: 'text-center' do %>
              <%= content_tag(:span, 'XXX') %>
            <% end %>
          <% end %>
        <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
        <table class="table table-hover">
          <tr>
            <td class="text-center">
              <span>XXX</span></td></tr><tr>
            <td class="text-center">
              <span>XXX</span></td></tr>
        </table>
      HTML
      assert_equal(html, render(erb))
    end
  end

  describe "當沒有資料時..." do
    before do
      @table = SuperTableTest.new([])
    end

    should "顯示 placeholder" do
      erb = <<-ERB.strip_heredoc
        <%= super_table(table) do |t| %>
          <%= t.columns do |order| %>
            <%= t.column class: 'text-center' do %>
              <%= content_tag(:span, 'XXX') %>
            <% end %>
          <% end %>
        <% end %>
      ERB
      html = <<-HTML.strip_heredoc.gsub!("\n", "")
        <table class="table">
          <tr><td colspan="2" class="text-center"><span>尚無訂單資料，前往<a href=\"/orders/new\">新增</a>?</span></td></tr>
        </table>
      HTML
      assert_equal(html, render(erb))
    end
  end
end
