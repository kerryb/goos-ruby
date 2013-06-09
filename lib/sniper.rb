require "blather/client/client"
require "tk"

class Sniper
  attr_reader :status

  def initialize id, passsword, item_id
    @status = "Joining"
    @item_id = item_id

    start_xmpp_client id, passsword
    setup_ui
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
        client.write Blather::Stanza::Message.new(auction_id, "")
      end
    end

    client.register_handler :message do |m|
      @status = "Lost"
    end

    Thread.new do
      EM.run do
        client.connect
      end
    end
  end

  def setup_ui
    ui_root = TkRoot.new
    label = TkLabel.new(ui_root)
    label.text = status
    label.pack
  end
end
