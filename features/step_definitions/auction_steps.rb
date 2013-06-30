Given "an auction of an item is in progress" do
  start_auction_for_item("item-54321")
end

When "I am told the current price, bid increment and high bidder" do
  auction.report_price 1000, 98, "other bidder"
end

When "I am told that I am the high bidder" do
  auction.report_price 1098, 97, ApplicationRunner::SNIPER_ID
  expect(sniper).to be_winning_auction
end

When "the auction closes" do
  auction.close
end
