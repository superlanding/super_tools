module SuperInteraction
  module ControllerHelper
    def js(&block)
      i = Command.new(self)
      yield(i) if block_given?
      i
    end
  end
end
