require "sniper_snapshot"

class AuctionSniper
  def initialize auction, item_id, sniper_listener
    @auction, @item_id, @sniper_listener = auction, item_id, sniper_listener
    @is_winning = false
  end

  def current_price price, increment, price_source
    @is_winning = price_source == :from_sniper
    if @is_winning
      @sniper_listener.sniper_winning
    else
      bid = price + increment
      @auction.bid bid
      @sniper_listener.sniper_bidding SniperSnapshot.new(@item_id, price, bid)
    end
  end

  def auction_closed
    @is_winning ?  @sniper_listener.sniper_won : @sniper_listener.sniper_lost
  end
end
