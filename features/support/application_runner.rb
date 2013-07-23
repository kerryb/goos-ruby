require "main"

class ApplicationRunner
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"
  AuctionState = Struct.new :last_price, :last_bid

  def start_bidding_in *auctions
    @auction_states = Hash[*(auctions.flat_map {|a| [a, AuctionState.new(0, 0)] })]

    @application = Main.main SNIPER_ID, SNIPER_PASSWORD, *auctions.map(&:item_id)
    wait_for_app_to_start
    wait_for_window_title Ui::MainWindow::APPLICATION_TITLE
    wait_for_column_headers "Item", "Last price", "Last bid", "State"

    auctions.each do |auction|
      wait_for_displayed_row auction.item_id, 0, 0, SniperState::JOINING.to_s
    end
  end

  def stop
    @application.stop
  end

  def bidding? auction, last_price, last_bid
    @auction_states[auction] = AuctionState.new last_price, last_bid
    wait_for_displayed_row(auction.item_id,
                           last_price,
                           last_bid,
                           SniperState::BIDDING.to_s)
  end

  def winning_auction? auction
    wait_for_displayed_row(auction.item_id,
                           @auction_states[auction].last_bid,
                           @auction_states[auction].last_bid,
                           SniperState::WINNING.to_s)
  end

  def has_lost_auction? auction
    wait_for_displayed_row(auction.item_id,
                           @auction_states[auction].last_price,
                           @auction_states[auction].last_bid,
                           SniperState::LOST.to_s)
  end

  def has_won_auction? auction
    wait_for_displayed_row(auction.item_id,
                           @auction_states[auction].last_bid,
                           @auction_states[auction].last_bid,
                           SniperState::WON.to_s)
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

  def wait_for_window_title title
    wait_for { window.title == title } or fail(
      %{Expected window title to be "#{title}", but was "#{window.title}"})
  end

  def wait_for_column_headers *headers
    wait_for { displayed_headers == headers } or fail(
      %{Expected displayed headers to be #{headers.inspect}, but were #{displayed_headers.inspect}})
  end

  def wait_for_displayed_row *expected_values
    wait_for { displayed_rows.include? expected_values } or fail(
      %{Expected a row containing #{expected_values.inspect}, but table contained #{displayed_rows.inspect}})
  end

  def wait_for
    Timeout.timeout 2 do
      sleep 0.01 until yield
      return true
    end
  rescue Timeout::Error
    false
  end

  def displayed_rows
    table_model = window.child.model
    rows = []
    table_model.each do |_model, _path, iterator|
      rows << table_model.n_columns.times.map {|n| iterator[n]}
    end
    rows
  end

  def displayed_headers
    window.child.columns.map(&:title)
  end
end
