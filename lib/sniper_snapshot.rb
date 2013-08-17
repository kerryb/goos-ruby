require "sniper_state"

SniperSnapshot = Struct.new :item_id, :last_price, :last_bid, :sniper_state do
  def self.joining item_id
    new item_id, 0, 0, SniperState::JOINING
  end

  def bidding new_last_price, new_last_bid
    self.class.new item_id, new_last_price, new_last_bid, SniperState::BIDDING
  end

  def winning new_last_price
    self.class.new item_id, new_last_price, new_last_price, SniperState::WINNING
  end

  def losing new_last_price
    self.class.new item_id, new_last_price, last_bid, SniperState::LOSING
  end

  def closed
    self.class.new item_id, last_price, last_bid, sniper_state.when_auction_closed
  end

  def failed
    self.class.new item_id, 0, 0, SniperState::FAILED
  end

  def winning?
    sniper_state.winning?
  end
end
