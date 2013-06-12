require "blather/client/client"
require "gtk2"
require "drb"

require "ui/main_window"

class Main
  def initialize item_id
    @item_id = item_id
  end

  def self.main id, passsword, item_id
    new(item_id).start id, passsword
  end

  def self.drb_connection
    DRbObject.new_with_uri DRB_URI
  end

  def start id, passsword
    start_xmpp_client id, passsword
    start_ui
  end

  private

  DRB_URI = "druby://localhost:8787"

  attr_reader :client, :item_id, :window, :status_label

  def auction_id
    "auction-#{item_id}@localhost"
  end

  def start_xmpp_client id, passsword
    @client = Blather::Client.setup id, passsword

    client.register_handler :ready do
      EM.next_tick do
        client.write Blather::Stanza::Message.new(auction_id, "")
      end
    end

    client.register_handler :message do |m|
      window.status_label.text = "Lost"
    end

    Thread.new { EM.run { client.connect } }
  end

  # Blocks main thread
  def start_ui
    @window = Ui::MainWindow.new
    enable_remote_test_access window
    Gtk.init
    Gtk.main
  end

  def enable_remote_test_access window
    DRb.start_service DRB_URI, window
  end
end
