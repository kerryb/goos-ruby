When "I start bidding in the auction" do
  sniper.start_bidding_in auction => 999999
  auction.wait_for_join_request_from_sniper ApplicationRunner::SNIPER_ID
end

When "I start bidding in the auction, specifying a stop price" do
  sniper.start_bidding_in auction => 1100
  auction.wait_for_join_request_from_sniper ApplicationRunner::SNIPER_ID
end

When "I bid in both auctions" do
  sniper.start_bidding_in auction_1 => 999999, auction_2 => 999999
  auction_1.wait_for_join_request_from_sniper ApplicationRunner::SNIPER_ID
  auction_2.wait_for_join_request_from_sniper ApplicationRunner::SNIPER_ID
end

Then "I should place a higher bid" do
  expect(sniper).to be_bidding auction, 1000, 1098
  auction.wait_for_sniper_to_bid 1098, ApplicationRunner::SNIPER_ID
end

Then "I should have lost the auction" do
  expect(sniper).to have_lost_auction auction
end

Then "I should have won the auction" do
  expect(sniper).to have_won_auction auction
end

Then "I should win both items" do
  auction_1.report_price 1000, 98, "other bidder"
  expect(sniper).to be_bidding auction_1, 1000, 1098
  auction_1.wait_for_sniper_to_bid 1098, ApplicationRunner::SNIPER_ID

  auction_2.report_price 500, 21, "other bidder"
  expect(sniper).to be_bidding auction_2, 500, 521
  auction_2.wait_for_sniper_to_bid 521, ApplicationRunner::SNIPER_ID

  auction_1.report_price 1098, 97, ApplicationRunner::SNIPER_ID
  auction_2.report_price 521, 20, ApplicationRunner::SNIPER_ID

  expect(sniper).to be_winning_auction auction_1
  expect(sniper).to be_winning_auction auction_2

  auction_1.close
  auction_2.close

  expect(sniper).to have_won_auction auction_1
  expect(sniper).to have_won_auction auction_2
end

Then %r{(?:that auction should|the first auction should still) be shown as failed} do
  expect(sniper).to have_marked_auction_as_failed auction_1
end

Then "I should bid on the second item as normal" do
  expect(sniper).to be_bidding auction_2, 500, 521
end

Then "the message from the failed auction should be logged" do
  pending
end
