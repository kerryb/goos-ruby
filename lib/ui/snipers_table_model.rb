require "gtk2"
require "sniper_snapshot"
require "column"

class SnipersTableModel < Gtk::ListStore
  def initialize
    super String, Integer, Integer, String
  end

  def add_sniper sniper_snapshot
    row = append
    update_row row, sniper_snapshot
  end

  def sniper_state_changed sniper_snapshot
    update_row row_for(sniper_snapshot), sniper_snapshot
  end

  def row_for sniper_snapshot
    each do |_model, _path, iterator|
      return iterator if iterator[Column.values.find_index Column::ITEM_IDENTIFIER] == sniper_snapshot.item_id
    end
    raise Defect.new "Row not found"
  end

  def update_row row, sniper_snapshot
    Column.values.each_with_index do |column, index|
      row[index] = column.value_in sniper_snapshot
    end
  end
end
