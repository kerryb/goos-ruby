require "blather/client/client"
require "tk"
require "drb"

class Sniper
  def initialize id, passsword, item_id
    @item_id = item_id
    setup_ui
    update_status "Joining"
    start_xmpp_client id, passsword
    start_ui
  end

  def self.drb_connection
    DRb.start_service
    DRbObject.new_with_uri DRB_URI
  end

  private

  DRB_URI = "druby://localhost:8787"

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

  def setup_ui
    @ui_root = TkRoot.new { title "Auction sniper" }
    status = @status = TkVariable.new # @status is out of scope in block below
    status_label = TkLabel.new(ui_root) do
      width 20
      textvariable status
      pack
    end
    enable_remote_test_access
  end

  # Blocks main thread
  def start_ui
    Tk.mainloop
  end

  def enable_remote_test_access
    DRb.start_service DRB_URI, Tk.root
  end

  def update_status value
    status.value = value
    ui_root.update
  end
end
