require "super_table/builder"

module SuperTable
  module ActionView

    def super_table(table, options={}, &block)

      options[:hover] = options.fetch(:hover, true)
      is_hover = options.delete(:hover)
      table_responsive = options.delete(:responsive)
      table_size = options.delete(:size).to_s

      classes = ["table"]
      classes << options[:class] if options[:class]
      classes.push("table-hover") if is_hover && table.collection.present?
      classes.push("table-sm") if table_size == "sm"

      options[:class] = classes.join(" ")

      case table_responsive.to_s
      when "sm", "md", "lg", "xl"
        content_tag(:div, class: "table-responsive-#{table_responsive}") do
          render_table(table, options, &block)
        end
      else
        render_table(table, options, &block)
      end
    end

    protected

    def render_table(table, options={}, &block)
      content_tag(:table, options) do
        yield Builder.new(table, self) if block_given?
      end
    end
  end

  ::ActionView::Base.send :include, ActionView
end
