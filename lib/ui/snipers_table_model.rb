class SnipersTableModel < Gtk::ListStore
  def initialize
    super String
    @row = append
  end

  def status_text= text
    @row[0] = text
  end
end
