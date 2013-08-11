require "gtk2"

module Ui
  class MainWindow < Gtk::Window
    APPLICATION_TITLE = "Auction sniper"
    MAIN_WINDOW_NAME = "main_window"
    NEW_ITEM_ID_NAME = "new_item_id"
    STOP_PRICE_NAME = "stop_price"
    JOIN_BUTTON_NAME = "join"
    SNIPERS_TABLE_NAME = "snipers"

    def initialize portfolio
      super()
      @user_request_listeners = []
      @model = Ui::SnipersTableModel.new
      portfolio.add_portfolio_listener @model

      set_name MAIN_WINDOW_NAME
      set_title APPLICATION_TITLE
      signal_connect "destroy" do
        Gtk.main_quit
      end

      layout = Gtk::VBox.new false, 5
      layout.add make_new_item_form
      layout.add make_snipers_table
      add layout
      show_all
    end

    def add_user_request_listener listener
      @user_request_listeners << listener
    end

    def sniper_state_changed sniper_snapshot
      @model.sniper_state_changed sniper_snapshot
    end

    private

    def make_new_item_form
      layout = Gtk::HBox.new false, 5

      item_id_input = Gtk::Entry.new
      item_id_input.name = NEW_ITEM_ID_NAME

      stop_price_input = Gtk::Entry.new
      stop_price_input.name = STOP_PRICE_NAME

      button = Gtk::Button.new "Join Auction"
      button.name = JOIN_BUTTON_NAME
      button.signal_connect("clicked") {
        @user_request_listeners.each {|l| l.join_auction item_id_input.text }
      }

      layout.add Gtk::Label.new("Item:")
      layout.add item_id_input
      layout.add Gtk::Label.new("Stop price:")
      layout.add stop_price_input
      layout.add button
      layout
    end

    def make_snipers_table
      view = Gtk::TreeView.new @model
      view.name = SNIPERS_TABLE_NAME
      renderer = Gtk::CellRendererText.new
      Column.values.each_with_index do |column, index|
        view.append_column Gtk::TreeViewColumn.new(column.title, renderer, text: index)
      end
      view
    end
  end
end
