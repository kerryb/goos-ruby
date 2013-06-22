class AuctionSniper
  def initialize auction, sniper_listener
    @auction, @sniper_listener = auction, sniper_listener
    @is_winning = false
  end

  def current_price price, increment, price_source
    @is_winning = price_source == :from_sniper
    if @is_winning
      @sniper_listener.sniper_winning
    else
      @auction.bid price + increment
      @sniper_listener.sniper_bidding
    end
  end

  def auction_closed
    @is_winning ?  @sniper_listener.sniper_won : @sniper_listener.sniper_lost
  end
end
