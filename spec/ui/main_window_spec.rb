require_relative "../../test_support/auction_sniper_driver"
require "ui/main_window"

describe Ui::MainWindow do
  describe "when join button clicked" do
    subject(:window) { Ui::MainWindow.new SnipersTableModel.new }
    let(:driver) { AuctionSniperDriver.new window }

    it "yields the item ID to  user request listeners" do
      yielded = :did_not_yield
      window.add_user_request_listener do |item_id|
        yielded = item_id
      end

      driver.start_bidding_for "item-123"
      expect(yielded).to eq "item-123"
    end
  end
end
