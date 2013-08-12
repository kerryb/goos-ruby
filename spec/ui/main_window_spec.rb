require_relative "../../test_support/auction_sniper_driver"
require "support/roles/portfolio_listener"
require "ui/main_window"
require "sniper_portfolio"

describe Ui::MainWindow do
  subject(:window) { Ui::MainWindow.new SniperPortfolio.new }

  describe "when join button clicked" do
    let(:driver) { AuctionSniperDriver.new window }
    let(:listener) { double :listener, join_auction: true }

    it "passes the item details to  user request listeners" do
      window.add_user_request_listener listener

      driver.start_bidding_for "item-123", 789
      expect(listener).to have_received(:join_auction).with Item.new("item-123", 789)
    end
  end
end
