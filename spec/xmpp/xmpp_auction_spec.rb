require "xmpp/xmpp_auction"
require "support/roles/auction"

describe Xmpp::XmppAuction do
  subject { Xmpp::XmppAuction.new connection, item }
  let(:connection) {
    double :connection, register_handler: true, jid: double(stripped: "sniper")
  }
  let(:item) { double :item, identifier: "item-123" }

  it_behaves_like "an auction"
end
