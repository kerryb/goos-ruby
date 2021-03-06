require "support/roles/auction_event_listener"
require "xmpp/auction_message_translator"

describe Xmpp::AuctionMessageTranslator do
  subject { Xmpp::AuctionMessageTranslator.new sniper_id, auction_event_listener, failure_reporter }
  let(:sniper_id) { "sniper@localhost" }
  let(:auction_event_listener) { double :auction_event_listener }
  let(:failure_reporter) { double :failure_reporter, cannot_translate_message: true }

  def expect_failure_with_message bad_message
    expect(auction_event_listener).to have_received :auction_failed
    expect(failure_reporter).to have_received(:cannot_translate_message)
    .with sniper_id, bad_message, a_kind_of(Exception)
  end

  it "notifies bid details when it receives a current price message from another bidder" do
    allow(auction_event_listener).to receive :current_price
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: Someone else;"
    subject.handle_message message
    expect(auction_event_listener).to have_received(:current_price).with 192, 7, :from_other_bidder
  end

  it "notifies bid details when it receives a current price message from the sniper" do
    allow(auction_event_listener).to receive :current_price
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: #{sniper_id};"
    subject.handle_message message
    expect(auction_event_listener).to have_received(:current_price).with 192, 7, :from_sniper
  end

  it "notifies that the auction is closed when it receives a close message" do
    allow(auction_event_listener).to receive :auction_closed
    message = double :message, body: "SOLVersion: 1.1; Event: CLOSE;"
    subject.handle_message message
    expect(auction_event_listener).to have_received :auction_closed
  end

  it "notifies that the auction has failed when it receives an invalid message" do
    allow(auction_event_listener).to receive :auction_failed
    message = double :message, body: "a bad message"
    subject.handle_message message
    expect_failure_with_message message.body
  end

  it "notifies that the auction has failed when the event type is missing" do
    allow(auction_event_listener).to receive :auction_failed
    message = double :message,
      body: "SOLVersion: 1.1; CurrentPrice: 192; Increment: 7; Bidder: #{sniper_id};"
    subject.handle_message message
    expect_failure_with_message message.body
  end

  it "notifies that the auction has failed when the current price is missing" do
    allow(auction_event_listener).to receive :auction_failed
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; Increment: 7; Bidder: #{sniper_id};"
    subject.handle_message message
    expect_failure_with_message message.body
  end

  it "notifies that the auction has failed when the increment is missing" do
    allow(auction_event_listener).to receive :auction_failed
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Bidder: #{sniper_id};"
    subject.handle_message message
    expect_failure_with_message message.body
  end

  it "notifies that the auction has failed when the bidder is missing" do
    allow(auction_event_listener).to receive :auction_failed
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7;"
    subject.handle_message message
    expect_failure_with_message message.body
  end
end
