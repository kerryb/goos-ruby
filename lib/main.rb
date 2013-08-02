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

  def initialize id, passsword, *item_ids
    @snipers = SnipersTableModel.new
    @main_window = Ui::MainWindow.new @snipers
    client = setup_xmpp_client id, passsword
    start_ui
    add_user_request_listener_for client
    client.connect
  end

  def stop
    main_window.destroy
  end

  private

  def add_user_request_listener_for client
    @main_window.add_user_request_listener do |item_id|
      @snipers.add_sniper SniperSnapshot.joining item_id
      auction = XmppAuction.new client, auction_id_for(item_id)
      client.register_handler(:ready) { auction.join }
      auction_sniper = AuctionSniper.new(auction,
                                         item_id,
                                         UiThreadSniperListener.new(@snipers))
      translator = AuctionMessageTranslator.new client.jid.stripped.to_s, auction_sniper
      client.register_handler :message,
        ->(message) { message.from.node == "auction-#{item_id}" } do |message|
        translator.handle_message message
      end
    end
  end

  def auction_id_for item_id
    "auction-#{item_id}@localhost"
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
