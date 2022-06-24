module SuperProcess
  module Basic

    def method_missing(m, *args, &block)
      if block_given?
        new.public_send(m, *args, &block)
      else
        new.public_send(m, *args)
      end
    end
  end
end
