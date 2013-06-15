require "auction_message_translator"

describe AuctionMessageTranslator do
  subject { AuctionMessageTranslator.for listener }
  let(:listener) { double :listener, auction_closed: true }

  it "notifies that the auction is closed when it receives a close message" do
    message = double :message, body: "SOLVersion: 1.1; Event: CLOSE;"
    subject.call message
    expect(listener).to have_received :auction_closed
  end
end
