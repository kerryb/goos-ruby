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
    auction = XmppAuction.new @client, auction_id_for(item_id)
    @client.register_handler(:ready) { auction.join }
    @client.register_handler :message,
      &AuctionMessageTranslator.for(AuctionSniper.new(auction, SniperStateDisplayer.new(main_window)))
    @client.connect
    start_ui
  end

  def stop
    main_window.destroy
  end

  private

  def auction_id_for item_id
    "auction-#{item_id}@localhost"
  end

  def setup_xmpp_client id, passsword
    @client = Blather::Client.setup id, passsword
  end

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end
end
