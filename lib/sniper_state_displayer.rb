class SniperStateDisplayer
  def initialize main_window
    @main_window = main_window
  end

  def sniper_bidding state
    EM.next_tick { @main_window.sniper_status_changed state, "Bidding"}
  end

  def sniper_winning
    show_status "Winning"
  end

  def sniper_won
    show_status "Won"
  end

  def sniper_lost
    show_status "Lost"
  end

  private

  def show_status status
    EM.next_tick { @main_window.show_status status }
  end
end
