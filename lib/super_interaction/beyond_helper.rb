module SuperInteraction
  module BeyondHelper
    def beyond(&block)
      i = Beyond.new(self)
      yield(i) if block_given?
      i
    end
  end
end
