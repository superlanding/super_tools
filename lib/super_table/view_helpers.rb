module SuperTable
  module ViewHelpers

    def td(*args, &block)
      content_tag(:td, *args, &block)
    end

    def tr(*args, &block)
      content_tag(:tr, *args, &block)
    end

    def th(*args, &block)
      content_tag(:th, *args, &block)
    end

    def strong(*args, &block)
      content_tag(:strong, *args, &block)
    end

    def div(*args, &block)
      content_tag(:div, *args, &block)
    end

    def small(*args, &block)
      content_tag(:small, *args, &block)
    end

    def del(*args, &block)
      content_tag(:del, *args, &block)
    end

    def span(*args, &block)
      content_tag(:span, *args, &block)
    end

    def self.included(base)
      base.include ::ActionView::Context
      base.include ::ActionView::Helpers
    end
  end
end
