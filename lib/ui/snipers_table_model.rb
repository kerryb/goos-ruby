require "gtk2"
require "sniper_snapshot"
require "column"

class SnipersTableModel < Gtk::ListStore
  def initialize item_id
    super String, Integer, Integer, String
    @row = append
    sniper_state_changed SniperSnapshot.new(item_id, 0, 0, SniperState::JOINING)
  end

  def sniper_state_changed sniper_snapshot
    Column.values.each_with_index do |column, index|
      @row[index] = column.value_in sniper_snapshot
    end
  end
end
