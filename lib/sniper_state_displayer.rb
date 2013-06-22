class SniperStateDisplayer
  def initialize main_window
    @main_window = main_window
  end

  def sniper_bidding
    show_status "Bidding"
  end

  def sniper_winning
    show_status "Winning"
  end

  def sniper_lost
    show_status "Lost"
  end

  private

  def show_status status
    EM.next_tick { @main_window.status_label.text = status }
  end
end
