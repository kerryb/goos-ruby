require "auction_sniper"
require "ui_thread_sniper_listener"
require "ui/main_window"
require "xmpp_auction"

class Main
  attr_reader :ui

  class << self
    alias main new
  end

  def initialize username, passsword
    @snipers = SnipersTableModel.new
    @ui = Ui::MainWindow.new @snipers
    connection = setup_xmpp_client username, passsword
    start_ui
    disconnect_when_ui_closes connection
    add_user_request_listener_for connection
    connection.connect
  end

  def stop
    ui.destroy
  end

  private

  def disconnect_when_ui_closes connection
    @ui.signal_connect :destroy do
      connection.close
    end
  end

  def add_user_request_listener_for connection
    ui.add_user_request_listener do |item_id|
      @snipers.add_sniper SniperSnapshot.joining item_id
      auction = XmppAuction.new connection, item_id
      (@not_to_be_gced ||= []) << auction
      connection.register_handler(:ready) { auction.join }
      auction.add_event_listener(
        AuctionSniper.new(item_id, auction,
                          UiThreadSniperListener.new(@snipers)))
    end
  end

  def setup_xmpp_client username, passsword
    Blather::Client.setup username, passsword
  end

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end
end
