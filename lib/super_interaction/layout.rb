module SuperInteraction
  module Layout

    FRAMEWORKS = [ :bootstrap3, :bootstrap4, :beyond ]

    def self.framework=(f)
      raise "Not support framework: #{f}" if FRAMEWORKS.include?(f) == false
      @@framework = f
    end

    def self.framework
      @@framework
    end

    def self.modal_layout
      case @@framework
      when :bootstrap3
        "modal_bs3.haml"
      when :bootstrap4
        "modal_bs4.haml"
      when :beyond
        "modal_beyond.haml"
      else
        # Default
        "modal_bs3.haml"
      end
    end
  end
end
