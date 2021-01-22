module SuperInteraction
  module Layout
    mattr_accessor :framework
    self.framework = :bootstrap3

    def self.modal_layout
      case framework
      when :bootstrap3
        "modal_bs3.haml"
      when :bootstrap4
        "modal_bs4.haml"
      when :beyond
        "modal_beyond.haml"
      end
    end
  end
end
