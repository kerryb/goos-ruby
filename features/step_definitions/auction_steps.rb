Given "an auction of an item is in progress" do
  start_auction_for_item("item-54321")
end

Given "auctions of two items are in progress" do
  start_auction_for_item("item-54321")
  start_auction_for_item("item-65432")
end

When "I am told the current price, bid increment and high bidder" do
  auction.report_price 1000, 98, "other bidder"
end

When "I am told that I am the high bidder" do
  auction.report_price 1098, 97, ApplicationRunner::SNIPER_ID
  expect(sniper).to be_winning_auction auction
end

When "other bidders push the auction over my stop price" do
  auction.report_price 1000, 98, "other bidder"
  expect(sniper).to be_bidding auction, 1000, 1098
  auction.wait_for_sniper_to_bid 1098, ApplicationRunner::SNIPER_ID
  auction.report_price 1197, 10, "third party"
  expect(sniper).to be_losing_auction auction, 1197, 1098
  auction.report_price 1207, 10, "fourth party"
  expect(sniper).to be_losing_auction auction, 1207, 1098
end

When "the auction closes" do
  auction.close
end

When "I receive an invalid event from one auction" do
  auction_1.send_invalid_message_containing "a broken message"
end

When "I receive further events from both auctions" do
  auction_1.report_price 1000, 98, "other bidder"
  auction_2.report_price 500, 21, "other bidder"
end
