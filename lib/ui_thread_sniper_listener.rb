class UiThreadSniperListener
  def initialize delegate
    @delegate = delegate
  end

  def sniper_state_changed state
    EM.next_tick { @delegate.sniper_state_changed state }
  end
end
