require "auction_sniper"

describe AuctionSniper do
  subject { AuctionSniper.new sniper_listener }
  let(:sniper_listener) { double :sniper_listener, sniper_lost: true }

  it "reports that the sniper has lost when the action closes" do
    subject.auction_closed
    expect(sniper_listener).to have_received :sniper_lost
  end
end
