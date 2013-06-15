module RunsFakeAuction
  attr_reader :auction

  def start_auction_for_item id
    @auction = FakeAuctionServer.new(id)
    auction.start_selling_item
  end
end
World RunsFakeAuction

After { auction.stop if @auction }
