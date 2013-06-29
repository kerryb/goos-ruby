require "gtk2"
require "sniper_state"

class SnipersTableModel < Gtk::ListStore
  COLUMNS = [:item_id, :last_price, :last_bid, :sniper_status]
  def COLUMNS.index_of column
    find_index column
  end

  def initialize
    super String, Integer, Integer, String
    @row = append
    sniper_status_changed SniperState.new("", 0, 0), "Joining"
  end

  def sniper_status_changed sniper_state, status_text
    @row[COLUMNS.index_of :item_id] = sniper_state.item_id
    @row[COLUMNS.index_of :last_price] = sniper_state.last_price
    @row[COLUMNS.index_of :last_bid] = sniper_state.last_bid
    @row[COLUMNS.index_of :sniper_status] = status_text
  end

  def status_text= text
    @row[COLUMNS.index_of :sniper_status] = text
  end
end
