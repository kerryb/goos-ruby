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
    run
  end

  def wait_for_join_request_from_sniper
    Timeout.timeout 5 do
      sleep 0.1 until has_received_message?
    end
  end

  def close
  end

  private

  attr_reader :client

  def auction_password
    "auction"
  end

  def auction_login
    "auction-#{item_id}@localhost"
  end

  def has_received_message?
    @message
  end

  def run
    Thread.new do
      EM.run do
        client.run
      end
    end
  end
end
