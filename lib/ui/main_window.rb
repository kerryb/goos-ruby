require "gtk2"
require "ui/snipers_table_model"

module Ui
  class MainWindow < Gtk::Window
    APPLICATION_TITLE = "Auction sniper"
    MAIN_WINDOW_NAME = "main_window"
    NEW_ITEM_ID_NAME = "new_item_id"
    JOIN_BUTTON_NAME = "join"
    SNIPERS_TABLE_NAME = "snipers"

    def initialize sniper_listener
      super()
      @sniper_listener = sniper_listener
      @user_request_listeners = []

      set_name MAIN_WINDOW_NAME
      set_title APPLICATION_TITLE
      signal_connect "destroy" do
        Gtk.main_quit
      end

      layout = Gtk::VBox.new
      layout.add make_new_item_form
      layout.add make_snipers_table
      add layout
      show_all
    end

    def add_user_request_listener listener
      @user_request_listeners << listener
    end

    def show_status status
      @sniper_listener.status_text = status
    end

    def sniper_state_changed sniper_snapshot
      @sniper_listener.sniper_state_changed sniper_snapshot
    end

    private

    def make_new_item_form
      layout = Gtk::HBox.new
      input = Gtk::Entry.new
      input.name = NEW_ITEM_ID_NAME
      button = Gtk::Button.new "Join Auction"
      button.name = JOIN_BUTTON_NAME
      button.signal_connect("clicked") {
        @user_request_listeners.each {|l| l.join_auction input.text }
      }
      layout.add input
      layout.add button
      layout
    end

    def make_snipers_table
      view = Gtk::TreeView.new @sniper_listener
      view.name = SNIPERS_TABLE_NAME
      renderer = Gtk::CellRendererText.new
      Column.values.each_with_index do |column, index|
        view.append_column Gtk::TreeViewColumn.new(column.title, renderer, text: index)
      end
      view
    end
  end
end
