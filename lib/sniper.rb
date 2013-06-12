require "blather/client/client"
require "gtk2"
require "drb"

class Sniper
  def initialize id, passsword, item_id
    @item_id = item_id
    start_xmpp_client id, passsword
    start_ui
  end

  def self.drb_connection
    DRbObject.new_with_uri DRB_URI
  end

  private

  DRB_URI = "druby://localhost:8787"

  class SniperWindow < Gtk::Window
    def initialize
      super

      set_title  "Auction sniper"
      signal_connect "destroy" do
        Gtk.main_quit
      end

      init_ui
      show_all
    end

    def init_ui
      fixed = Gtk::Fixed.new
    end
  end


  attr_reader :client, :item_id, :ui_root, :status

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
      update_status "Lost"
    end

    Thread.new { EM.run { client.connect } }
  end

  # Blocks main thread
  def start_ui
    window = SniperWindow.new
    enable_remote_test_access window
    Gtk.init
    Gtk.main
  end

  def enable_remote_test_access window
    DRb.start_service DRB_URI, window
  end

  def update_status value
    status.value = value
    ui_root.update
  end
end
