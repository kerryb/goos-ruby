class AuctionSniper
  def initialize auction, sniper_listener
    @auction, @sniper_listener = auction, sniper_listener
  end

  def current_price price, increment
    @auction.bid price + increment
    @sniper_listener.sniper_bidding
  end

  def auction_closed
    @sniper_listener.sniper_lost
  end
end
