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
      sleep 0.01 until all_widgets_of_type(Gtk::Label).any? {|e| e.text == status }
      return true
    end
  rescue Timeout::Error
    labels = all_widgets_of_type(Gtk::Label).map(&:text)
    fail %{Looking for label with text "#{status}", but only found #{labels.inspect}}
  end

  def all_widgets_of_type type
    widget_and_children(window).flatten.select {|w| w.is_a? type }
  end

  def widget_and_children widget
    return [widget] unless widget.respond_to? :children
    [widget] + widget.children.map {|w| widget_and_children w }
  end
end
