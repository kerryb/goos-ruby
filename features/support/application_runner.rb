require "main"

class ApplicationRunner
  SNIPER_ID = "sniper@localhost"
  SNIPER_PASSWORD = "sniper"
  AuctionState = Struct.new :last_price, :last_bid

  def start_bidding_in auctions_with_stop_prices
    auctions = auctions_with_stop_prices.keys
    @auction_states = Hash[*(auctions.flat_map {|a| [a, AuctionState.new(0, 0)] })]
    @application = Main.main SNIPER_ID, SNIPER_PASSWORD
    @driver = AuctionSniperDriver.new @application.ui
    @driver.wait_for_app_to_start

    auctions.each do |auction|
      @driver.start_bidding_for auction.item_id, auctions_with_stop_prices[auction]
      @driver.wait_for_displayed_sniper_status auction.item_id, 0, 0, SniperState::JOINING.to_s
    end
  end

  def stop
    @application.stop
  end

  def bidding? auction, last_price, last_bid
    @auction_states[auction] = AuctionState.new last_price, last_bid
    @driver.wait_for_displayed_sniper_status(auction.item_id,
                                             last_price,
                                             last_bid,
                                             SniperState::BIDDING.to_s)
  end

  def winning_auction? auction
    @driver.wait_for_displayed_sniper_status(auction.item_id,
                                             @auction_states[auction].last_bid,
                                             @auction_states[auction].last_bid,
                                             SniperState::WINNING.to_s)
  end

  def losing_auction? auction, last_price, last_bid
    @auction_states[auction] = AuctionState.new last_price, last_bid
    @driver.wait_for_displayed_sniper_status(auction.item_id,
                                             last_price,
                                             last_bid,
                                             SniperState::LOSING.to_s)
  end

  def has_lost_auction? auction
    @driver.wait_for_displayed_sniper_status(auction.item_id,
                                             @auction_states[auction].last_price,
                                             @auction_states[auction].last_bid,
                                             SniperState::LOST.to_s)
  end

  def has_won_auction? auction
    @driver.wait_for_displayed_sniper_status(auction.item_id,
                                             @auction_states[auction].last_bid,
                                             @auction_states[auction].last_bid,
                                             SniperState::WON.to_s)
  end

  def has_marked_auction_as_failed? auction
    @driver.wait_for_displayed_sniper_status(auction.item_id, 0, 0,
                                             SniperState::FAILED.to_s)
  end
end
