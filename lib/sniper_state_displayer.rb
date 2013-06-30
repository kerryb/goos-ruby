class SniperStateDisplayer
  def initialize main_window
    @main_window = main_window
  end

  def sniper_state_changed state
    EM.next_tick { @main_window.sniper_state_changed state }
  end
end
