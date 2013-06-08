module RunsFakeAuction
  def start_auction_for_item id
    FakeAuctionServer.new(id).start_selling_item
  end
end
World RunsFakeAuction
