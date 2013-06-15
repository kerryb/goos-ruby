require "auction_message_translator"

describe AuctionMessageTranslator do
  subject { AuctionMessageTranslator.for listener }
  let(:listener) { double :listener, current_price: true, auction_closed: true }

  it "notifies bid details when it receives a current price message" do
    message = double :message,
      body: "SOLVersion: 1.1; Event: PRICE; CurrentPrice: 192; Increment: 7; Bidder: Someone else;"
    subject.call message
    expect(listener).to have_received(:current_price).with 192, 7
  end

  it "notifies that the auction is closed when it receives a close message" do
    message = double :message, body: "SOLVersion: 1.1; Event: CLOSE;"
    subject.call message
    expect(listener).to have_received :auction_closed
  end
end
