require "sniper"

class ApplicationDriver
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"

  def start_bidding_in auction
    @sniper = Sniper.new SNIPER_ID, SNIPER_PASSWORD, auction.item_id
  end

  def has_lost_auction?
    Timeout.timeout 2 do
      sleep 0.1 until sniper.status == "Lost"
    end
  end

  private

  attr_reader :sniper
end
