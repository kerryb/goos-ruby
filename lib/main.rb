require "sniper_launcher"
require "ui/snipers_table_model"
require "ui/main_window"
require "xmpp/xmpp_auction_house"

class Main
  attr_reader :ui

  class << self
    alias main new
  end

  def initialize username, passsword
    @snipers = SnipersTableModel.new
    @ui = Ui::MainWindow.new @snipers
    auction_house = Xmpp::XmppAuctionHouse.new username, passsword
    start_ui
    disconnect_when_ui_closes auction_house
    ui.add_user_request_listener SniperLauncher.new(auction_house, @snipers)
  end

  def stop
    ui.destroy
  end

  private

  def disconnect_when_ui_closes auction_house
    @ui.signal_connect :destroy do
      auction_house.disconnect
    end
  end

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end
end
