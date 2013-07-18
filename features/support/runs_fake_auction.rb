module RunsFakeAuction
  def start_auction_for_item id
    @auctions ||= []
    auction = FakeAuctionServer.new(id)
    @auctions.push auction
    auction.start_selling_item
  end

  def auction_1
    @auctions[0]
  end
  alias auction auction_1

  def auction_2
    @auctions[1]
  end
end
World RunsFakeAuction

After { @auctions.each(&:stop) }
