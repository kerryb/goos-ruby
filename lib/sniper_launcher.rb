require "sniper_snapshot"
require "auction_sniper"
require "ui_thread_sniper_listener"

class SniperLauncher
  def initialize auction_house, snipers
    @auction_house, @snipers = auction_house, snipers
  end

  def join_auction item_id
    @snipers.add_sniper SniperSnapshot.joining item_id
    auction = @auction_house.auction_for item_id
    (@not_to_be_gced ||= []) << auction
    auction.add_event_listener(
      AuctionSniper.new(item_id, auction,
                        UiThreadSniperListener.new(@snipers)))
  end
end
