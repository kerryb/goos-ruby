require "sniper"

class ApplicationDriver
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"

  def start_bidding_in auction
    @sniper = Sniper.new SNIPER_ID, SNIPER_PASSWORD, auction.item_id
    wait_for_status "Joining"
  end

  def has_lost_auction?
    wait_for_status "Lost"
  end

  private

  attr_reader :sniper

  def wait_for_status status
    Timeout.timeout 2 do
      sleep 0.1 until Tk.root.winfo_children.any? {|e| e.text == status }
      return true
    end
  end
end
