class SniperPortfolio
  def initialize
    @snipers = []
    @listeners = []
  end

  def add_portfolio_listener listener
    @listeners << listener
  end

  def add_sniper sniper
    @snipers << sniper
    @listeners.each {|l| l.sniper_added sniper }
  end
end
