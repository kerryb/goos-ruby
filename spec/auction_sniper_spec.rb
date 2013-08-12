require "support/roles/auction"
require "support/roles/sniper_listener"
require "support/roles/auction_event_listener"
require "auction_sniper"
require "item"

describe AuctionSniper do
  subject { AuctionSniper.new item, auction }
  let(:auction) { double :auction, join: true, bid: true }
  let(:item_id) { "item-123" }
  let(:item) { Item.new item_id, 1234 }
  let(:price) { 1001 }
  let(:increment) { 25 }
  let(:sniper_listener) { double :sniper_listener }

  before { subject.add_sniper_listener sniper_listener }

  it_behaves_like "an auction event listener"

  context "when a new price arrives" do
    before { sniper_listener.stub :sniper_state_changed }

    context "from the sniper" do
      before { subject.current_price price, increment, :from_sniper }

      it "reports that it's winning" do
        expect(sniper_listener).to have_received(:sniper_state_changed).with(
          SniperSnapshot.new(item_id, price, price, SniperState::WINNING)
        )
      end
    end

    context "from another bidder, within the stop price" do
      before { subject.current_price price, increment, :from_other_bidder }

      it "bids higher" do
        expect(auction).to have_received(:bid).with(price + increment)
      end

      it "reports that it's bidding" do
        expect(sniper_listener).to have_received(:sniper_state_changed).with(
          SniperSnapshot.new(item_id, price, price + increment, SniperState::BIDDING)
        )
      end
    end

    context "from another bidder, going over the stop price" do
      let(:price) { 2345 }
      before { subject.current_price price, increment, :from_other_bidder }

      it "does not bid" do
        expect(auction).to_not have_received :bid
      end

      it "reports that it's losing" do
        expect(sniper_listener).to have_received(:sniper_state_changed).with(
          SniperSnapshot.new(item_id, price, 0, SniperState::LOSING)
        )
      end
    end

  end

  it "reports that the sniper has lost when the action closes immediately" do
    sniper_listener.stub :sniper_state_changed
    subject.auction_closed
    expect(sniper_listener).to have_received(:sniper_state_changed).with(
      SniperSnapshot.new(item_id, 0, 0, SniperState::LOST)
    )
  end

  it "reports that the sniper has lost when the action closes while bidding" do
    sniper_listener.stub(:sniper_state_changed) do |snapshot|
      if snapshot.sniper_state == SniperState::WINNING
        expect(@sniper_state).to be SniperState::BIDDING
      else
        @sniper_state = snapshot.sniper_state
      end
    end

    subject.current_price price, increment, :from_other_bidder
    subject.auction_closed

    expect(sniper_listener).to have_received(:sniper_state_changed).with(
      SniperSnapshot.new(item_id, price, price + increment, SniperState::LOST)
    )
  end

  it "reports that the sniper has won when the action closes while winning" do
    sniper_listener.stub(:sniper_state_changed) {|snapshot| @sniper_state = snapshot.sniper_state }
    sniper_listener.stub(:sniper_won) { expect(@sniper_state).to be SniperState::WINNING }

    subject.current_price price, increment, :from_sniper
    subject.auction_closed

    expect(sniper_listener).to have_received(:sniper_state_changed).with(
      SniperSnapshot.new(item_id, price, price, SniperState::WON)
    )
  end
end
