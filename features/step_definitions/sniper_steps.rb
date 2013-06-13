When "I start bidding in the auction" do
  sniper.start_bidding_in auction
  auction.wait_for_join_request_from_sniper ApplicationRunner::SNIPER_ID
end

Then "I should place a higher bid" do
  expect(sniper).to be_bidding
  auction.wait_for_bid 1098, ApplicationRunner::SNIPER_ID
end

Then "I should have lost the auction" do
  expect(sniper).to have_lost_auction
end
