require "gtk2"
require "ui/snipers_table_model"

module Ui
  class MainWindow < Gtk::Window
    APPLICATION_TITLE = "Auction sniper"

    def initialize sniper_listener
      super()
      @sniper_listener = sniper_listener

      set_name "main_window"
      set_title APPLICATION_TITLE
      signal_connect "destroy" do
        Gtk.main_quit
      end

      add make_snipers_table
      show_all
    end

    def show_status status
      @sniper_listener.status_text = status
    end

    def sniper_state_changed sniper_snapshot
      @sniper_listener.sniper_state_changed sniper_snapshot
    end

    private

    def make_snipers_table
      view = Gtk::TreeView.new @sniper_listener
      view.name = "snipers"
      renderer = Gtk::CellRendererText.new
      Column.values.each_with_index do |_, index|
        view.append_column Gtk::TreeViewColumn.new("", renderer, text: index)
      end
      view
    end
  end
end
