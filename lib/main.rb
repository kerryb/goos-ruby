require "blather/client/client"
require "gtk2"

require "ui/main_window"

class Main
  JOIN_COMMAND_FORMAT = "SOLVersion: 1.1; Command: JOIN;"
  PRICE_EVENT_FORMAT = "SOLVersion: 1.1; Event: PRICE; CurrentPrice: %d; Increment: %d; Bidder: %s;"
  BID_COMMAND_FORMAT = "SOLVersion: 1.1; Command: BID; Price: %d;"
  CLOSE_EVENT_FORMAT = "SOLVersion: 1.1; Event: CLOSE;"

  attr_reader :main_window

  def initialize item_id
    @item_id = item_id
  end

  def self.main id, passsword, item_id
    new(item_id).tap {|m| m.start id, passsword }
  end

  def start id, passsword
    start_xmpp_client id, passsword
    start_ui
  end

  def stop
    stop_xmpp_client
    stop_ui
  end

  private

  attr_reader :client, :item_id

  def auction_id
    "auction-#{item_id}@localhost"
  end

  def start_xmpp_client id, passsword
    @client = Blather::Client.setup id, passsword

    client.register_handler :ready do
      EM.next_tick do
        client.write Blather::Stanza::Message.new(auction_id, JOIN_COMMAND_FORMAT)
      end
    end

    client.register_handler :message do |m|
      main_window.status_label.text = "Lost"
    end

    client.connect
  end

  def stop_xmpp_client
    EM.next_tick { client.stop }
  end

  # Blocks main thread
  def start_ui
    @main_window = Ui::MainWindow.new
    Gtk.init
    Thread.new { Gtk.main }
  end

  def stop_ui
    main_window.destroy
  end
end
