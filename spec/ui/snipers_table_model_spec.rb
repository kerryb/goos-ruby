require "support/roles/sniper_listener"
require "support/roles/sniper_collector"
require "ui/snipers_table_model"
#TODO isolate from AuctionSniper
require "auction_sniper"

describe Ui::SnipersTableModel do
  let(:auction) { double :auction }

  def rows
    rows = []
    subject.each do |_model, _path, iter|
      rows << [
        iter[Column::ITEM_IDENTIFIER.index],
        iter[Column::LAST_PRICE.index],
        iter[Column::LAST_BID.index],
        iter[Column::SNIPER_STATE.index],
      ]
    end
    rows
  end

  it_behaves_like "a sniper listener"
  it_behaves_like "a sniper collector"

  it "Has enough columns" do
    expect(subject.n_columns).to eq Column.values.size
  end

  context "initially" do
    it "does not have any rows" do
      expect(subject.iter_first).to be_false
    end
  end

  describe "#add_sniper" do
    it "sets the item ID, last price, last bid and sniper status" do
      subject.add_sniper AuctionSniper.new("item-123", auction)
      expect(rows).to eq [["item-123", 0, 0, SniperState::JOINING.to_s]]
    end
  end

  describe "#sniper_state_changed" do
    before do
      subject.add_sniper AuctionSniper.new("item-123", auction)
      subject.add_sniper AuctionSniper.new("item-456", auction)
      subject.add_sniper AuctionSniper.new("item-789", auction)
    end

    it "updates the values in the correct row" do
      state = SniperSnapshot.new("item-456", 100, 123, SniperState::BIDDING)
      subject.sniper_state_changed state
      expect(rows).to eq [
        ["item-123", 0, 0, SniperState::JOINING.to_s],
        ["item-456", 100, 123, SniperState::BIDDING.to_s],
        ["item-789", 0, 0, SniperState::JOINING.to_s],
        ]
    end
  end
end
