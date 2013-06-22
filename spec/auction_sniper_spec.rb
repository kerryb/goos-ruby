require "support/roles/auction"
require "support/roles/sniper_listener"
require "support/roles/auction_event_listener"
require "auction_sniper"

describe AuctionSniper do
  subject { AuctionSniper.new auction, sniper_listener }
  let(:auction) { double :auction, join: true, bid: true }
  let(:sniper_listener) { double :sniper_listener }

  it_behaves_like "an auction event listener"

  it "reports that it's winning when the current price is from the sniper" do
    sniper_listener.stub :sniper_winning
    subject.current_price 123, 45, :from_sniper
    expect(sniper_listener).to have_received :sniper_winning
  end

  context "when a new price arrives" do
    let(:price) { 1001 }
    let(:increment) { 25 }

    before do
      sniper_listener.stub :sniper_bidding
      subject.current_price price, increment, :from_other_bidder
    end

    it "bids higher" do
      expect(auction).to have_received(:bid).with(price + increment)
    end

    it "reports that it is bidding" do
      expect(sniper_listener).to have_received :sniper_bidding
    end
  end

  context "when the action closes" do
    before do
      sniper_listener.stub :sniper_lost
      subject.auction_closed
    end

    it "reports that the sniper has lost" do
      expect(sniper_listener).to have_received :sniper_lost
    end
  end
end
