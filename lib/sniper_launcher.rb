require "auction_sniper"
require "item"

class SniperLauncher
  def initialize auction_house, collector
    @auction_house, @collector = auction_house, collector
  end

  def join_auction item
    auction = @auction_house.auction_for item
    sniper = AuctionSniper.new item, auction
    auction.add_auction_event_listener sniper
    @collector.add_sniper sniper
    auction.join
  end
end
