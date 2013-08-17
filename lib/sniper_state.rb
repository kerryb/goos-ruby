require "defect"

SniperState = Struct.new :name, :winning, :new_state_when_auction_closed

class SniperState
  JOINING = new "Joining", false, :LOST
  BIDDING = new "Bidding", false, :LOST
  WINNING = new "Winning", true, :WON
  LOSING = new "Losing", false, :LOST
  LOST = new "Lost", false
  WON = new "Won", true
  FAILED = new "Failed", false

  def to_s
    name
  end

  def inspect
    "<SniperState: #{name}>"
  end

  def winning?
    winning
  end

  def when_auction_closed
    if new_state_when_auction_closed
      SniperState.const_get new_state_when_auction_closed
    else
      raise Defect.new("Auction is already closed")
    end
  end
end
