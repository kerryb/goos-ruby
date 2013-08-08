require "blather/client/client"

require "auction_sniper"
require "auction_message_translator"
require "ui_thread_sniper_listener"
require "ui/main_window"
require "xmpp/chat"
require "announcer"
require "xmpp_auction"

class Main
  attr_reader :ui

  class << self
    alias main new
  end

  def initialize id, passsword, *item_ids
    @snipers = SnipersTableModel.new
    @ui = Ui::MainWindow.new @snipers
    connection = setup_xmpp_client id, passsword
    start_ui
    add_user_request_listener_for connection
    connection.connect
  end

  def stop
    ui.destroy
  end

  private

  def add_user_request_listener_for connection
    ui.add_user_request_listener do |item_id|
      @snipers.add_sniper SniperSnapshot.joining item_id
      chat = Xmpp::Chat.new connection, auction_id_for(item_id)
      auction_event_listeners = Announcer.new
      (@not_to_be_gced ||= []) << chat
      auction = XmppAuction.new chat
      chat.add_message_listener(
        AuctionMessageTranslator.new connection.jid.stripped.to_s, auction_event_listeners
      )
      connection.register_handler(:ready) { auction.join }
      auction_event_listeners.add_listener(
        AuctionSniper.new(item_id, auction,
                          UiThreadSniperListener.new(@snipers)))
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
