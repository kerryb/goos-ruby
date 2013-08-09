require "xmpp/xmpp_auction_house"
require_relative "../../test_support/fake_auction_server"

describe Xmpp::XmppAuctionHouse do
  let(:auction_house) { Xmpp::XmppAuctionHouse.new "sniper@localhost", "sniper" }
  let(:auction) { auction_house.auction_for item_id }
  let(:item_id) { "item-54321" }
  let(:server) { FakeAuctionServer.new item_id }
  let(:listener) { double :listener }

  before do
    @em_thread = Thread.new { EM.run }
    sleep 0.01 until EM.reactor_running?
    system "cd vines; vines start -d &>/dev/null"
    server.start_selling_item
    listener.stub(:auction_closed) { @auction_close_event_received = true }
    auction.add_event_listener listener
  end

  after do
    system "cd vines; vines stop &>/dev/null"
    EM.stop_event_loop if EM.reactor_running?
    @em_thread.join
  end

  it "receives events from auction server after joining" do
    server.wait_for_join_request_from_sniper "sniper@localhost"
    server.close

    Timeout.timeout 5 do
      sleep 0.01 until @auction_close_event_received
    end
  end
end
