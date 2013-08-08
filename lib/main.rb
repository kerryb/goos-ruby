require "blather/client/client"

require "auction_sniper"
require "auction_message_translator"
require "ui_thread_sniper_listener"
require "ui/main_window"
require "xmpp/chat"
require "xmpp_auction"

class Main
  attr_reader :main_window

  class << self
    alias main new
  end

  def initialize id, passsword, *item_ids
    @snipers = SnipersTableModel.new
    @main_window = Ui::MainWindow.new @snipers
    connection = setup_xmpp_client id, passsword
    start_ui
    add_user_request_listener_for connection
    connection.connect
  end

  def stop
    main_window.destroy
  end

  private

  def add_user_request_listener_for connection
    @main_window.add_user_request_listener do |item_id|
      @snipers.add_sniper SniperSnapshot.joining item_id
      auction_id = auction_id_for item_id
      auction = XmppAuction.new connection, "#{auction_id}@localhost"
      connection.register_handler(:ready) { auction.join }
      chat = Xmpp::Chat.new connection, auction_id
      (@not_to_be_gced ||= []) << chat
      auction_sniper = AuctionSniper.new(auction, item_id,
                                         UiThreadSniperListener.new(@snipers))
      chat.add_message_listener(
        AuctionMessageTranslator.new connection.jid.stripped.to_s, auction_sniper
      )
    end
  end

  def auction_id_for item_id
    "auction-#{item_id}"
  end

  def setup_xmpp_client id, passsword
    Blather::Client.setup id, passsword
  end

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end
end
