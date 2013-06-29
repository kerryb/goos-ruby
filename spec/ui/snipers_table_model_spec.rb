require "ui/snipers_table_model"

describe SnipersTableModel do
  def value_of_column column
    subject.iter_first[SnipersTableModel::COLUMNS.index_of column]
  end

  it "Has enough columns" do
    expect(subject.n_columns).to eq SnipersTableModel::COLUMNS.size
  end

  context "initially" do
    it "sets a blank item ID, zero last price and last bid, and sniper status 'Joining'" do
      expect(value_of_column :item_id).to be_empty
      expect(value_of_column :last_price).to be_zero
      expect(value_of_column :last_bid).to eq be_zero
      expect(value_of_column :sniper_status).to eq "Joining"
    end
  end

  describe "#sniper_state_changed" do
    it "updates the item ID, last price, last bid and sniper status" do
      state = SniperSnapshot.new("item-123", 100, 123)
      subject.sniper_status_changed state, "Bidding"
      expect(value_of_column :item_id).to eq "item-123"
      expect(value_of_column :last_price).to eq 100
      expect(value_of_column :last_bid).to eq 123
      expect(value_of_column :sniper_status).to eq "Bidding"
    end
  end
end
