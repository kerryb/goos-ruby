require "sniper_state"

SniperSnapshot = Struct.new :item, :last_price, :last_bid, :sniper_state do
  def self.joining item
    new item, 0, 0, SniperState::JOINING
  end

  def bidding new_last_price, new_last_bid
    self.class.new item, new_last_price, new_last_bid, SniperState::BIDDING
  end

  def winning new_last_price
    self.class.new item, new_last_price, new_last_price, SniperState::WINNING
  end

  def closed
    self.class.new item, last_price, last_bid, sniper_state.when_auction_closed
  end

  def winning?
    sniper_state.winning?
  end
end
