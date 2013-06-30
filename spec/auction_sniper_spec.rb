require "support/roles/auction"
require "support/roles/sniper_listener"
require "support/roles/auction_event_listener"
require "auction_sniper"

describe AuctionSniper do
  subject { AuctionSniper.new auction, item_id, sniper_listener }
  let(:auction) { double :auction, join: true, bid: true }
  let(:item_id) { "item-123" }
  let(:sniper_listener) { double :sniper_listener }

  it_behaves_like "an auction event listener"


  context "when a new price arrives" do
    let(:price) { 1001 }
    let(:increment) { 25 }

    before { sniper_listener.stub :sniper_state_changed }

    context "from the sniper" do
      before { subject.current_price price, increment, :from_sniper }

      it "reports that it's winning" do
        expect(sniper_listener).to have_received(:sniper_state_changed).with(
          SniperSnapshot.new(item_id, price, price, :winning)
        )
      end
    end

    context "from another bidder" do
      before { subject.current_price price, increment, :from_other_bidder }

      it "bids higher" do
        expect(auction).to have_received(:bid).with(price + increment)
      end

      it "reports that it's bidding" do
        expect(sniper_listener).to have_received(:sniper_state_changed).with(
          SniperSnapshot.new(item_id, price, price + increment, :bidding)
        )
      end
    end
  end

  it "reports that the sniper has lost when the action closes immediately" do
    sniper_listener.stub :sniper_lost
    subject.auction_closed
    expect(sniper_listener).to have_received :sniper_lost
  end

  it "reports that the sniper has lost when the action closes while bidding" do
    sniper_listener.stub(:sniper_state_changed) {|snapshot| @sniper_state = snapshot.sniper_state }
    sniper_listener.stub(:sniper_lost) { expect(@sniper_state).to be :bidding }

    subject.current_price 123, 45, :from_other_bidder
    subject.auction_closed

    expect(sniper_listener).to have_received :sniper_lost
  end

  it "reports that the sniper has won when the action closes while winning" do
    sniper_listener.stub(:sniper_state_changed) {|snapshot| @sniper_state = snapshot.sniper_state }
    sniper_listener.stub(:sniper_won) { expect(@sniper_state).to be :winning }

    subject.current_price 123, 45, :from_sniper
    subject.auction_closed

    expect(sniper_listener).to have_received :sniper_won
  end
end
