require "sniper_snapshot"

describe SniperSnapshot do
  let(:item_id) { "item-123" }

  describe ".joining" do
    it "returns an initial snapshot" do
      expect(SniperSnapshot.joining item_id).to eq(
        SniperSnapshot.new(item_id, 0, 0, SniperState::JOINING)
      )
    end
  end

  describe "#bidding" do
    subject { SniperSnapshot.new item_id, 0, 0, SniperState::JOINING }
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    it "returns a new snapshot with last price and bid" do
      expect(subject.bidding last_price, last_bid ).to eq(
        SniperSnapshot.new(item_id, last_price, last_bid, SniperState::BIDDING)
      )
    end
  end

  describe "#winning" do
    subject { SniperSnapshot.new item_id, last_price, last_bid, SniperState::BIDDING }
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    it "returns a new snapshot with last price and bid" do
      expect(subject.winning last_bid ).to eq(
        SniperSnapshot.new(item_id, last_bid, last_bid, SniperState::WINNING)
      )
    end
  end

  describe "#losing" do
    subject { SniperSnapshot.new item_id, last_price, last_bid, SniperState::LOSING }
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    it "returns a new snapshot with last price and bid" do
      expect(subject.losing last_price ).to eq(
        SniperSnapshot.new(item_id, last_price, last_bid, SniperState::LOSING)
      )
    end
  end

  describe "#won" do
    subject { SniperSnapshot.new item_id, last_price, last_bid, SniperState::WINNING }
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    it "returns a new snapshot with last price and bid" do
      expect(subject.winning last_bid ).to eq(
        SniperSnapshot.new(item_id, last_bid, last_bid, SniperState::WINNING)
      )
    end
  end

  describe "#closed" do
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    context "when winning" do
      subject { SniperSnapshot.new item_id, last_price, last_bid, SniperState::WINNING }

      it "returns a new 'won' snapshot with last price and bid" do
        expect(subject.closed).to eq(
          SniperSnapshot.new(item_id, last_price, last_bid, SniperState::WON)
        )
      end
    end

    context "when not winning" do
      subject { SniperSnapshot.new item_id, last_price, last_bid, SniperState::BIDDING }

      it "returns a new 'lost' snapshot with last price and bid" do
        expect(subject.closed).to eq(
          SniperSnapshot.new(item_id, last_price, last_bid, SniperState::LOST)
        )
      end
    end
  end

  describe "#winning?" do
    it "returns true if the sniper state is WINNING" do
      expect(SniperSnapshot.new "", 0, 0, SniperState::WINNING).to be_winning
    end

    it "returns false if the sniper state is not WINNING" do
      expect(SniperSnapshot.new "", 0, 0, SniperState::BIDDING).to_not be_winning
    end
  end
end
