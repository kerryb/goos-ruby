require_relative "../../test_support/auction_sniper_driver"
require "support/roles/portfolio_listener"
require "ui/main_window"
require "ui/snipers_table_model"
require "sniper_portfolio"

describe Ui::MainWindow do
  subject(:window) { Ui::MainWindow.new SniperPortfolio.new }

  describe "when join button clicked" do
    let(:driver) { AuctionSniperDriver.new window }
    let(:listener) { double :listener, join_auction: true }

    it "passes the item ID to  user request listeners" do
      window.add_user_request_listener listener

      driver.start_bidding_for "item-123", 999999
      expect(listener).to have_received(:join_auction).with "item-123"
    end
  end
end
