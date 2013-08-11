require "sniper_launcher"
require "sniper_portfolio"
require "ui/snipers_table_model"
require "ui/main_window"
require "xmpp/xmpp_auction_house"

class Main
  attr_reader :ui

  class << self
    alias main new
  end

  def initialize username, passsword
    @portfolio = SniperPortfolio.new
    @ui = Ui::MainWindow.new @portfolio
    auction_house = Xmpp::XmppAuctionHouse.new username, passsword
    start_ui
    ui.add_user_request_listener SniperLauncher.new(auction_house, @portfolio)
  end

  def stop
    ui.destroy
  end

  private

  # Blocks main thread
  def start_ui
    Gtk.init
    Thread.new { Gtk.main }
  end
end
