require "defect"

class SniperState
  def initialize name
    @name = name
  end

  JOINING = new "Joining"
  def JOINING.when_auction_closed
    LOST
  end

  BIDDING = new "Bidding"
  def BIDDING.when_auction_closed
    LOST
  end

  WINNING = new "Winning"
  def WINNING.winning?
    true
  end
  def WINNING.when_auction_closed
    WON
  end

  LOST = new "Lost"
  WON = new "Won"

  def to_s
    @name
  end

  def inspect
    "<SniperState: #{@name}>"
  end

  def winning?
    false
  end

  def when_auction_closed
    raise Defect.new("Auction is already closed")
  end
end
