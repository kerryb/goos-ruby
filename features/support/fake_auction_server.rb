require "blather/client/client"

class FakeAuctionServer
  attr_reader :item_id

  def initialize item_id
    @item_id = item_id
  end

  def start_selling_item
    @client = Blather::Client.setup auction_login, auction_password
    client.register_handler :message do |m|
      @message = m
    end
    connect
  end

  def wait_for_join_request_from_sniper
    Timeout.timeout 5 do
      sleep 0.1 until has_received_message?
    end
  end

  def close
    EM.next_tick do
      client.write Blather::Stanza::Message.new(sniper_id, "")
    end
  end

  private

  attr_reader :client

  def auction_password
    "auction"
  end

  def auction_login
    "auction-#{item_id}@localhost"
  end

  def sniper_id
    "sniper@localhost"
  end

  def has_received_message?
    @message
  end

  def connect
    Thread.new do
      EM.run do
        client.connect
      end
    end
  end
end
