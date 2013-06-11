require "sniper"

class ApplicationDriver
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"

  def start_bidding_in auction
    fork do
      Sniper.new SNIPER_ID, SNIPER_PASSWORD, auction.item_id
    end
    wait_for_status "Joining"
  end

  def has_lost_auction?
    wait_for_status "Lost"
  end

  private

  def app
    @app ||= Sniper.drb_connection
  end

  def wait_for_status status
    Timeout.timeout 20 do
      sleep 0.1 until Tk.root.winfo_children.any? {|e| e.text == status }
      return true
    end
  rescue Timeout::Error => e
    labels = Tk.root.winfo_children.map(&:text)
    fail %{Looking for label with text "#{status}", but only found #{labels.inspect}}
  end
end
