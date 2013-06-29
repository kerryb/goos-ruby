require "main"

class ApplicationRunner
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"

  def start_bidding_in auction
    @application = Main.main SNIPER_ID, SNIPER_PASSWORD, auction.item_id
    wait_for_app_to_start
    wait_for_status "Joining"
  end

  def stop
    @application.stop
  end

  def bidding?
    wait_for_status "Bidding"
  end

  def winning_auction?
    wait_for_status "Winning"
  end

  def has_lost_auction?
    wait_for_status "Lost"
  end

  def has_won_auction?
    wait_for_status "Won"
  end

  private

  def window
    @application.main_window
  end

  def wait_for_app_to_start
    Timeout.timeout 10 do
      sleep 0.01 until @application.main_window.title == "Auction sniper"
    end
  end

  def wait_for_status status
    Timeout.timeout 2 do
      sleep 0.01 until displayed_status == status
      return true
    end
  rescue Timeout::Error
    fail %{Expected displayed status to be "#{status}", but was #{displayed_status}}
  end

  def displayed_status
    window.child.model.iter_first[0]
  end
end
