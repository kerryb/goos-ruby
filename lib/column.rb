class Column
  ITEM_IDENTIFIER = new
  def ITEM_IDENTIFIER.value_in sniper_snapshot
    sniper_snapshot.item_id
  end

  LAST_PRICE = new
  def LAST_PRICE.value_in sniper_snapshot
    sniper_snapshot.last_price
  end

  LAST_BID = new
  def LAST_BID.value_in sniper_snapshot
    sniper_snapshot.last_bid
  end

  SNIPER_STATE = new
  def SNIPER_STATE.value_in sniper_snapshot
    sniper_snapshot.sniper_state.to_s
  end

  def self.values
    [ITEM_IDENTIFIER, LAST_PRICE, LAST_BID, SNIPER_STATE]
  end
end
