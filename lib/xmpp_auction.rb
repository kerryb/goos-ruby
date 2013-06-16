require "blather/client/client"

class XmppAuction
  JOIN_COMMAND_FORMAT = "SOLVersion: 1.1; Command: JOIN;"
  BID_COMMAND_FORMAT = "SOLVersion: 1.1; Command: BID; Price: %d;"

  def initialize client, auction_id
    @client, @auction_id = client, auction_id
  end

  def join
    send_message JOIN_COMMAND_FORMAT
  end

  def bid amount
    send_message(BID_COMMAND_FORMAT % amount)
  end

  private

  attr_reader :client, :auction_id
  def send_message message
    EM.next_tick do
      client.write Blather::Stanza::Message.new(auction_id, message)
    end
  end
end
