require "blather/client/client"

require "auction_sniper"
require "auction_message_translator"
require "ui_thread_sniper_listener"
require "ui/main_window"
require "xmpp_auction"

class Main
  attr_reader :main_window

  class << self
    alias main new
  end

  def initialize id, passsword, item_id
    @snipers = SnipersTableModel.new item_id
    @main_window = Ui::MainWindow.new @snipers
    setup_xmpp_client id, passsword
    start_ui
    auction = XmppAuction.new @client, auction_id_for(item_id)
    @client.register_handler(:ready) { auction.join }
    auction_sniper = AuctionSniper.new(auction,
                                       item_id,
                                       UiThreadSniperListener.new(@snipers))
    @client.register_handler :message,
      &AuctionMessageTranslator.for(@client.jid.stripped.to_s, auction_sniper)
    @client.connect
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
