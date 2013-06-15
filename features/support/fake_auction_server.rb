require "blather/client/client"

class FakeAuctionServer
  PRICE_EVENT_FORMAT = "SOLVersion: 1.1; Event: PRICE; CurrentPrice: %d; Increment: %d; Bidder: %s;"
  CLOSE_EVENT_FORMAT = "SOLVersion: 1.1; Event: CLOSE;"

  attr_reader :item_id

  def initialize item_id
    @item_id = item_id
  end

  def start_selling_item
    Thread.new { EM.run } unless EM.reactor_running?
    @client = Blather::Client.setup auction_login, auction_password
    client.register_handler :message do |m|
      @message = m
    end
    connect
  end

  def report_price price, increment, current_high_bidder
    send_message PRICE_EVENT_FORMAT % [price, increment, current_high_bidder]
  end

  def close
    send_message CLOSE_EVENT_FORMAT
  end

  def wait_for_join_request_from_sniper sniper_id
    Timeout.timeout 5 do
      sleep 0.1 until has_received_message?(Main::JOIN_COMMAND_FORMAT, sniper_id)
    end
  end

  def wait_for_sniper_to_bid amount, sniper_id
    Timeout.timeout 5 do
      sleep 0.1 until has_received_message?(Main::BID_COMMAND_FORMAT % amount, sniper_id)
    end
  end

  def stop
    EM.next_tick { client.close }
  end

  private

  attr_reader :client, :message

  def auction_password
    "auction"
  end

  def auction_login
    "auction-#{item_id}@localhost"
  end

  def sniper_id
    "sniper@localhost"
  end

  def send_message message
    EM.next_tick do
      client.write Blather::Stanza::Message.new(sniper_id, message)
    end
  end

  def has_received_message? text, sender
    message && message.body == text && message.from.stripped == sender
  end

  def connect
    client.connect
  end
end
