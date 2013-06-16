require "support/roles/auction"
require "support/roles/sniper_listener"
require "support/roles/auction_event_listener"
require "auction_sniper"

describe AuctionSniper do
  subject { AuctionSniper.new auction, sniper_listener }
  let(:auction) { double :auction, join: true, bid: true }
  let(:sniper_listener) { double :sniper_listener, sniper_bidding: true, sniper_lost: true }

  describe "the auction double used in this spec" do
    subject { auction }
    it_behaves_like "an auction"
  end

  describe "the sniper listener double used in this spec" do
    subject { sniper_listener }
    it_behaves_like "a sniper listener"
  end

  it_behaves_like "an auction event listener"

  context "when a new price arrives" do
    let(:price) { 1001 }
    let(:increment) { 25 }

    before { subject.current_price price, increment }

    it "bids higher" do
      expect(auction).to have_received(:bid).with(price + increment)
    end

    it "reports that it is bidding" do
      expect(sniper_listener).to have_received :sniper_bidding
    end
  end

  context "when the action closes" do
    before { subject.auction_closed }

    it "reports that the sniper has lost" do
      expect(sniper_listener).to have_received :sniper_lost
    end
  end
end
