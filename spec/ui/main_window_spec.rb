require_relative "../../test_support/auction_sniper_driver"
require "ui/main_window"

describe Ui::MainWindow do
  describe "when join button clicked" do
    subject(:window) { Ui::MainWindow.new SnipersTableModel.new }
    let(:driver) { AuctionSniperDriver.new window }
    let(:listener) { double :listener, join_auction: true }

    it "passes the item ID to  user request listeners" do
      window.add_user_request_listener listener

      driver.start_bidding_for "item-123"
      expect(listener).to have_received(:join_auction).with "item-123"
    end
  end
end
