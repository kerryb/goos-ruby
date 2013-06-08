module RunsFakeAuction
  attr_reader :auction

  def start_auction_for_item id
    @auction = FakeAuctionServer.new(id)
    auction.start_selling_item
  end

  def close
    auction.close
  end
end
World RunsFakeAuction
