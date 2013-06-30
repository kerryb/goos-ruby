class SniperStateDisplayer
  def initialize main_window
    @main_window = main_window
  end

  def sniper_state_changed state
    EM.next_tick { @main_window.sniper_state_changed state }
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
