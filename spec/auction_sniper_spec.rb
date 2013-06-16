require "support/interfaces/sniper_listener"
require "support/interfaces/auction_event_listener"
require "auction_sniper"

describe AuctionSniper do
  subject { AuctionSniper.new sniper_listener }
  let(:sniper_listener) { double :sniper_listener, sniper_bidding: true, sniper_lost: true }

  describe "the sniper listener double used in this spec" do
    subject { sniper_listener }
    it_behaves_like "a sniper listener"
  end

  it_behaves_like "an auction event listener"

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
