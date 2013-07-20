require "support/roles/sniper_listener"
require "ui/snipers_table_model"

describe SnipersTableModel do
  subject { SnipersTableModel.new "item-123" }

  def value_of_column column
    subject.iter_first[Column.values.find_index column]
  end

  it_behaves_like "a sniper listener"

  it "Has enough columns" do
    expect(subject.n_columns).to eq Column.values.size
  end

  context "initially" do
    it "sets the supplied item ID, zero last price and last bid, and sniper status 'Joining'" do
      expect(value_of_column Column::ITEM_IDENTIFIER).to eq "item-123"
      expect(value_of_column Column::LAST_PRICE).to be_zero
      expect(value_of_column Column::LAST_BID).to eq be_zero
      expect(value_of_column Column::SNIPER_STATE).to eq SniperState::JOINING.to_s
    end
  end

  describe "#sniper_state_changed" do
    it "updates the item ID, last price, last bid and sniper state" do
      state = SniperSnapshot.new("item-456", 100, 123, SniperState::BIDDING)
      subject.sniper_state_changed state
      expect(value_of_column Column::ITEM_IDENTIFIER).to eq "item-456"
      expect(value_of_column Column::LAST_PRICE).to eq 100
      expect(value_of_column Column::LAST_BID).to eq 123
      expect(value_of_column Column::SNIPER_STATE).to eq SniperState::BIDDING.to_s
    end
  end
end
