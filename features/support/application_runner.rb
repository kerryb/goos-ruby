require "main"

class ApplicationRunner
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"

  def start_bidding_in auction
    Thread.new do
      Main.main SNIPER_ID, SNIPER_PASSWORD, auction.item_id
    end
    wait_for_app_to_start
    wait_for_status "Joining"
  end

  def stop
    app.stop
  end

  def has_lost_auction?
    wait_for_status "Lost"
  end

  private

  def wait_for_app_to_start
    Timeout.timeout 10 do
      loop do
        begin
          sleep 0.1
          return if Main.drb_connection.respond_to? :title
        rescue Errno::ECONNREFUSED, DRb::DRbConnError, DRb::DRbServerNotFound
        end
      end
    end
  end

  def app
    @app ||= Main.drb_connection
  end

  def wait_for_status status
    Timeout.timeout 2 do
      sleep 0.1 until all_widgets_of_type(Gtk::Label).any? {|e| e.text == status }
      return true
    end
  rescue Timeout::Error => e
    labels = all_widgets_of_type(Gtk::Label).map(&:text)
    fail %{Looking for label with text "#{status}", but only found #{labels.inspect}}
  end

  def all_widgets_of_type type
    widget_and_children(app).flatten.select {|w| w.is_a? type }
  end

  def widget_and_children widget
    return [widget] unless widget.respond_to? :children
    [widget] + widget.children.map {|w| widget_and_children w }
  end
end
