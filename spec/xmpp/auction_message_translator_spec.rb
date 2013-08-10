require "support/roles/auction_event_listener"
require "xmpp/auction_message_translator"

describe Xmpp::AuctionMessageTranslator do
  subject { Xmpp::AuctionMessageTranslator.new sniper_id, auction_event_listener }
  let(:sniper_id) { "sniper@localhost" }
  let(:auction_event_listener) { double :auction_event_listener }

  it "notifies bid details when it receives a current price message from another bidder" do
    auction_event_listener.stub :current_price
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: Someone else;"
    subject.handle_message message
    expect(auction_event_listener).to have_received(:current_price).with 192, 7, :from_other_bidder
  end

  it "notifies bid details when it receives a current price message from the sniper" do
    auction_event_listener.stub :current_price
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: #{sniper_id};"
    subject.handle_message message
    expect(auction_event_listener).to have_received(:current_price).with 192, 7, :from_sniper
  end

  it "notifies that the auction is closed when it receives a close message" do
    auction_event_listener.stub :auction_closed
    message = double :message, body: "SOLVersion: 1.1; Event: CLOSE;"
    subject.handle_message message
    expect(auction_event_listener).to have_received :auction_closed
  end
end