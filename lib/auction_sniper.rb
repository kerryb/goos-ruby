class AuctionSniper
  def initialize auction, sniper_listener
    @auction, @sniper_listener = auction, sniper_listener
  end

  def current_price price, increment, price_source
    case price_source
    when :from_sniper
      @sniper_listener.sniper_winning
    when :from_other_bidder
      @auction.bid price + increment
      @sniper_listener.sniper_bidding
    end
  end

  def auction_closed
    @sniper_listener.sniper_lost
  end
end
