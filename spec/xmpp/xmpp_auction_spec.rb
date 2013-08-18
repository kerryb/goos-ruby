require "xmpp/xmpp_auction"
require "item"
require "support/roles/auction"
require "support/roles/auction_event_listener"

describe Xmpp::XmppAuction do
  subject { Xmpp::XmppAuction.new connection, item }
  let(:connection) {
    double :connection, register_handler: true, jid: double(stripped: "sniper")
  }
  let(:item) { Item.new "item-123" }

  it_behaves_like "an auction"

end

describe Xmpp::XmppAuction::ChatDisconnector do
  let(:chat) { double(:chat) }
  let(:translator) { double(:translator) }
  subject { Xmpp::XmppAuction::ChatDisconnector.new chat, translator }

  it_behaves_like "an auction event listener"

  it "removes the translator from the chat when the auction fails" do
    allow(chat).to receive :remove_message_listener
    subject.auction_failed
    expect(chat).to have_received(:remove_message_listener).with translator
  end
end
