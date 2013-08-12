require "column"

describe Column do
  let(:snapshot) {
    double(:snapshot, item: double(identifier: "item-123"),
           last_price: 100, last_bid: 110,
           sniper_state: double(to_s: "Joining"))
  }

  [Column::ITEM_IDENTIFIER, Column::LAST_PRICE,
   Column::LAST_BID, Column::SNIPER_STATE].each_with_index do |column, index|
    specify "The '#{column.title} column has an index of {index}" do
      expect(column.index).to eq index
    end
  end

  specify "#values returns all values" do
    expect(Column.values).to eq [Column::ITEM_IDENTIFIER,
                                 Column::LAST_PRICE,
                                 Column::LAST_BID,
                                 Column::SNIPER_STATE]
  end

  [
    ["ITEM_IDENTIFIER", "Item", "item.identifier"],
    ["LAST_PRICE", "Last price", "last_price"],
    ["LAST_BID", "Last bid", "last_bid"],
    ["SNIPER_STATE", "State", "sniper_state.to_s"],
  ].each do |(column, title, field)|
    describe column do
      subject { Column.const_get column }

      its(:title) { should eq title }

      it "returns the sniper snapshot value in #{field}" do
        expect(subject.value_in snapshot).to be snapshot.instance_eval(field)
      end
    end
  end
end
