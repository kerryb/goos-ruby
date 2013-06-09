require "sniper"

class ApplicationDriver
  SNIPER_ID = "sniper"
  SNIPER_PASSWORD = "sniper"

  attr_reader :sniper

  def start_bidding_in auction
    @sniper = Sniper.new SNIPER_ID, SNIPER_PASSWORD, auction.item_id
  end

  def wait_for_status_to_be status
    Timeout.timeout 2 do
      sleep 0.1 until sniper.status == status
    end
  end

  def has_lost_auction?
    wait_for_status_to_be "Lost"
  end
end
