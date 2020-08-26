module SuperInteraction
  module BootstrapHelper
    def js(&block)
      i = Bootstrap.new(self)
      yield(i) if block_given?
      i
    end
  end
end
