require "ui/snipers_table_model"

module Ui
  class MainWindow < Gtk::Window
    def initialize
      super

      set_name "main_window"
      set_title  "Auction sniper"
      signal_connect "destroy" do
        Gtk.main_quit
      end

      @snipers = SnipersTableModel.new
      add make_snipers_table
      show_all
    end

    def show_status status
      @snipers.status_text = status
    end

    def sniper_status_changed sniper_state, status_text
      @snipers.sniper_status_changed sniper_state, status_text
    end

    private

    def make_snipers_table
      view = Gtk::TreeView.new @snipers
      view.name = "snipers"
      renderer = Gtk::CellRendererText.new
      view.append_column Gtk::TreeViewColumn.new("A", renderer, text: 0)
      view
    end
  end
end
