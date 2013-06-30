require "column"

describe Column do
  let(:snapshot) {
    double(:snapshot, item_id: item_id, last_price: last_price,
           last_bid: last_bid, sniper_state: sniper_state)
  }
  let(:item_id) { "item-123" }
  let(:last_price) { 100 }
  let(:last_bid) { 120 }
  let(:sniper_state) { double :sniper_state, to_s: sniper_state_string }
  let(:sniper_state_string) { "Joining" }

  specify "#values returns all values" do
    expect(Column.values).to eq [Column::ITEM_IDENTIFIER,
                                 Column::LAST_PRICE,
                                 Column::LAST_BID,
                                 Column::SNIPER_STATE]
  end

  describe "::ITEM_IDENTIFIER" do
    subject { Column::ITEM_IDENTIFIER }
    it "returns the sniper snapshot value in item_id" do
      expect(subject.value_in snapshot).to be item_id
    end
  end

  describe "::LAST_PRICE" do
    subject { Column::LAST_PRICE }
    it "returns the sniper snapshot value in last_price" do
      expect(subject.value_in snapshot).to be last_price
    end
  end

  describe "::LAST_BID" do
    subject { Column::LAST_BID }
    it "returns the sniper snapshot value in last_bid" do
      expect(subject.value_in snapshot).to be last_bid
    end
  end

  describe "::SNIPER_STATE" do
    subject { Column::SNIPER_STATE }
    it "returns the sniper snapshot value in sniper_state, converted to a string" do
      expect(subject.value_in snapshot).to be sniper_state_string
    end
  end
end
