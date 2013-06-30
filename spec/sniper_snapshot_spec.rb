require "sniper_snapshot"

describe SniperSnapshot do
  let(:item_id) { "item-123" }

  describe ".joining" do
    it "returns an initial snapshot" do
      expect(SniperSnapshot.joining item_id).to eq(
        SniperSnapshot.new(item_id, 0, 0, :joining)
      )
    end
  end

  describe "#bidding" do
    subject { SniperSnapshot.new item_id, 0, 0, :joining }
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    it "returns a new snapshot with last price and bid" do
      expect(subject.bidding last_price, last_bid ).to eq(
        SniperSnapshot.new(item_id, last_price, last_bid, :bidding)
      )
    end
  end

  describe "#winning" do
    subject { SniperSnapshot.new item_id, last_price, last_bid, :bidding }
    let(:last_price) { 100 }
    let(:last_bid) { 110 }

    it "returns a new snapshot with last price and bid" do
      expect(subject.winning last_bid ).to eq(
        SniperSnapshot.new(item_id, last_bid, last_bid, :winning)
      )
    end
  end

  describe "#winning?" do
    it "returns true if the sniper state is :winning" do
      expect(SniperSnapshot.new "", 0, 0, :winning).to be_winning
    end

    it "returns false if the sniper state is not :winning" do
      expect(SniperSnapshot.new "", 0, 0, :bidding).to_not be_winning
    end
  end
end
