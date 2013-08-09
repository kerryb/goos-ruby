require "auction_sniper"
require "ui_thread_sniper_listener"
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
    add_user_request_listener_for auction_house
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

  def add_user_request_listener_for auction_house
    ui.add_user_request_listener do |item_id|
      @snipers.add_sniper SniperSnapshot.joining item_id
      auction = auction_house.auction_for item_id
      (@not_to_be_gced ||= []) << auction
      auction.add_event_listener(
        AuctionSniper.new(item_id, auction,
                          UiThreadSniperListener.new(@snipers)))
    end
  end

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end
end
