class SniperStateDisplayer
  def initialize main_window
    @main_window = main_window
  end

  def sniper_bidding
    main_window.status_label.text = "Bidding"
  end

  def sniper_lost
    main_window.status_label.text = "Lost"
  end

  private

  attr_reader :main_window
end
