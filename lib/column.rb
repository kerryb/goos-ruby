Column = Struct.new :title, :snapshot_extractor

class Column
  ITEM_IDENTIFIER = new "Item", ->(s) { s.item_id }
  LAST_PRICE = new "Last price", ->(s) { s.last_price }
  LAST_BID = new "Last bid", ->(s) { s.last_bid }
  SNIPER_STATE = new "State", ->(s) { s.sniper_state.to_s }

  def self.values
    [ITEM_IDENTIFIER, LAST_PRICE, LAST_BID, SNIPER_STATE]
  end

  def value_in sniper_snapshot
    snapshot_extractor.(sniper_snapshot)
  end
end
