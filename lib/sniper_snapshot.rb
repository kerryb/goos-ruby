SniperSnapshot = Struct.new :item_id, :last_price, :last_bid, :sniper_state do
  def self.joining item_id
    new item_id, 0, 0, :joining
  end

  def bidding last_price, last_bid
    self.class.new item_id, last_price, last_bid, :bidding
  end

  def winning last_price
    self.class.new item_id, last_price, last_price, :winning
  end

  def winning?
    sniper_state == :winning
  end
end
