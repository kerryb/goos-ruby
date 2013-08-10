require "sniper_snapshot"

class AuctionSniper
  attr_reader :snapshot

  def initialize item_id, auction
    @item_id, @auction, = item_id, auction
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
    notify_change
  end

  def add_sniper_listener sniper_listener
    @sniper_listener = sniper_listener
  end

  def auction_closed
    @snapshot = @snapshot.closed
    notify_change
  end

  private

  def notify_change
    @sniper_listener.sniper_state_changed @snapshot
  end
end
