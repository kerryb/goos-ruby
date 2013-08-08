require "blather/client/client"

class XmppAuction
  JOIN_COMMAND_FORMAT = "SOLVersion: 1.1; Command: JOIN;"
  BID_COMMAND_FORMAT = "SOLVersion: 1.1; Command: BID; Price: %d;"

  def initialize chat
    @chat = chat
  end

  def join
    send_message JOIN_COMMAND_FORMAT
  end

  def bid amount
    send_message(BID_COMMAND_FORMAT % amount)
  end

  private

  def send_message message
    @chat.send_message message
  end
end
