require "blather/client/client"

class Sniper
  attr_reader :status

  def initialize id, passsword, item_id
    @status = "Joining"
    @item_id = item_id

    @client = Blather::Client.setup id, passsword

    client.register_handler :ready do
      EM.next_tick do
        client.write Blather::Stanza::Message.new(auction_id, "")
      end
    end

    client.register_handler :message do |m|
      @status = "Lost"
    end

    connect
  end

  private

  attr_reader :client, :item_id

  def auction_id
    "auction-#{item_id}@localhost"
  end

  def connect
    Thread.new do
      EM.run do
        client.connect
      end
    end
  end
end
