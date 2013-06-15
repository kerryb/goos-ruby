require "auction_sniper"

describe AuctionSniper do
  subject { AuctionSniper.new sniper_listener }
  let(:sniper_listener) { double :sniper_listener, sniper_bidding: true, sniper_lost: true }

  context "when a new price arrives" do
    let(:price) { 1001 }
    let(:increment) { 25 }

    it "bids higher"
    it "reports that it is bidding" do
      subject.current_price price, increment
      expect(sniper_listener).to have_received :sniper_bidding
    end
  end

  context "when the action closes" do
    it "reports that the sniper has lost" do
      subject.auction_closed
      expect(sniper_listener).to have_received :sniper_lost
    end
  end
end
