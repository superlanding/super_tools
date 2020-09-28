module SuperInteraction
  module BeyondHelper
    def srj(&block)
      i = Beyond.new(self)
      if block_given?
        yield(i)
        i.run
      else
        i
      end
    end
  end
end
