require "gtk2"
require "sniper_snapshot"

class SnipersTableModel < Gtk::ListStore
  COLUMNS = [:item_id, :last_price, :last_bid, :sniper_state]
  SNIPER_STATES = {
    joining: "Joining",
    bidding: "Bidding",
    winning: "Winning",
    won: "Won",
    lost: "Lost"
  }
    
  def COLUMNS.index_of column
    find_index column
  end

  def initialize
    super String, Integer, Integer, String
    @row = append
    sniper_state_changed SniperSnapshot.new("", 0, 0, :joining)
  end

  def sniper_state_changed sniper_snapshot
    @row[COLUMNS.index_of :item_id] = sniper_snapshot.item_id
    @row[COLUMNS.index_of :last_price] = sniper_snapshot.last_price
    @row[COLUMNS.index_of :last_bid] = sniper_snapshot.last_bid
    @row[COLUMNS.index_of :sniper_state] = SNIPER_STATES[sniper_snapshot.sniper_state]
  end

  def status_text= text
    @row[COLUMNS.index_of :sniper_state] = text
  end
end
