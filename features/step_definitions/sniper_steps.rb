When "I start bidding in the auction" do
  sniper.start_bidding_in auction
  auction.wait_for_join_request_from_sniper
end

Then "I should have lost the auction" do
  expect(sniper).to have_lost_auction
end
