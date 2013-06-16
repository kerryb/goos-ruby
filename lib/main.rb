require "blather/client/client"
require "gtk2"

require "auction_sniper"
require "auction_message_translator"
require "sniper_state_displayer"
require "ui/main_window"
require "xmpp_auction"

class Main
  attr_reader :main_window

  class << self
    alias main new
  end

  def initialize id, passsword, item_id
    @main_window = Ui::MainWindow.new
    setup_xmpp_client id, passsword
    auction = XmppAuction.new client, auction_id_for(item_id)
    client.register_handler(:ready) { auction.join }
    client.register_handler :message,
      &AuctionMessageTranslator.for(AuctionSniper.new(auction, SniperStateDisplayer.new(main_window)))
    client.connect
    start_ui
  end

  def stop
    stop_xmpp_client
    stop_ui
  end

  private

  attr_reader :client

  def auction_id_for item_id
    "auction-#{item_id}@localhost"
  end

  def setup_xmpp_client id, passsword
    Thread.new { EM.run } unless EM.reactor_running?
    @client = Blather::Client.setup id, passsword
  end

  def stop_xmpp_client
    EM.next_tick { client.stop }
  end

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end

  def stop_ui
    main_window.destroy
  end
end
