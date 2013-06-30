require "sniper_snapshot"

class AuctionSniper
  def initialize auction, item_id, sniper_listener
    @auction, @item_id, @sniper_listener = auction, item_id, sniper_listener
    @snapshot = SniperSnapshot.joining item_id
  end

  def current_price price, increment, price_source
    if price_source == :from_sniper
      @snapshot = @snapshot.winning(price)
    else
      bid = price + increment
      @auction.bid bid
      @snapshot = @snapshot.bidding(price, bid)
    end
    @sniper_listener.sniper_state_changed @snapshot
  end

  def auction_closed
    @snapshot.winning? ?  @sniper_listener.sniper_won : @sniper_listener.sniper_lost
  end
end
