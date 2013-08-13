require "sniper_launcher"

describe SniperLauncher do
  subject { SniperLauncher.new auction_house, collector }
  let(:auction_house) { double :auction_house }
  let(:collector) { double :collector, add_sniper: true }
  let(:auction) { double :auction, add_event_listener: true }
  let(:item) { Item.new "item-123" }

  before do
    allow(auction_house).to receive(:auction_for).with(item) { auction }
  end

  it "adds a new sniper to the collector then joins the auction" do
    auction_state = :not_joined
    expect(auction).to receive :add_event_listener do |listener|
      expect(auction_state).to eq :not_joined
      expect(listener.snapshot.item_id).to eq "item-123"
    end
    expect(collector).to receive :add_sniper do |sniper|
      expect(auction_state).to eq :not_joined
      expect(sniper.snapshot.item_id).to eq "item-123"
    end
    expect(auction).to receive :join do
      auction_state = :joined
    end

    subject.join_auction item
  end
end
