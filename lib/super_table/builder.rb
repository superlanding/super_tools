require "super_table/view_helpers"
module SuperTable
  class Builder
    include ViewHelpers

    attr_accessor :table, :view_context

    delegate :content_tag, :concat, to: :view_context
    delegate :collection, to: :table

    def initialize(table, view_context)
      self.view_context = view_context
      self.table = table
    end

    def heads(*args, &block)
      options = args.extract_options!

      classes = ["table-secondary"]
      classes << options[:class] if options[:class]
      options[:class] = classes.join(" ")

      if block_given?
        tr(options, &block)
      else
        tr(options) do
          args.each do |key|
            concat head(key)
          end
        end
      end
    end

    def head(key=nil, options={}, &block)
      if block_given?
        options = key
        return th(options, &block)
      end

      case key
      when Symbol
        column_options = table.columns[key].clone
        title, desc = column_options.delete(:title), column_options.delete(:desc)
      else
        column_options = {}
        title = key
      end

      classes = []
      classes << options.delete(:class) if options[:class]
      classes << column_options.delete(:class) if column_options[:class]
      column_options.merge!(options)
      column_options.merge!(class: classes.join(" ")) if classes.present?

      th(column_options) do
        concat(title)
        concat content_tag(:div, desc, class: "small text-primary") if desc
      end
    end

    def columns(*args, &block)
      @rows = []
      options = args.extract_options!
      wrap_options = options.delete(:wrap) || {}
      if collection.empty?
        return placeholder_row
      end
      collection.each do |record|
        @rows << record
        html = wrap_tr(options, wrap_options) do
          if block_given?
            yield record
          else
            args.each do |key|
              concat td(record.send(key))
            end
          end
        end
        concat html
      end
      nil
    end

    def column(key=nil, options={}, &block)
      if block_given?
        options = key
        return td(options, &block)
      end

      content = case key
      when Symbol
        @rows.last.send(key)
      else
        key
      end
      td(content, options)
    end

    def placeholder_row
      tr do
        content = table.placeholder || "尚無資料"
        td(content, colspan: table.columns.length, class: "text-center")
      end
    end

    protected

    def wrap_tr(options, wrap_options={}, &block)
      if wrap_options == false
        block.()
      else
        tr(options, &block)
      end
    end
  end
end
