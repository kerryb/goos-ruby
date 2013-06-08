Given "an auction of an item is in progress" do
  start_auction_for_item("item-54321")
end

When "the auction closes" do
  auction.close
end
