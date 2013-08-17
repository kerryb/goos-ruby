require "xmpp/xmpp_auction"
require "item"
require "support/roles/auction"

describe Xmpp::XmppAuction do
  subject { Xmpp::XmppAuction.new connection, item }
  let(:connection) {
    double :connection, register_handler: true, jid: double(stripped: "sniper")
  }
  let(:item) { Item.new "item-123" }

  it_behaves_like "an auction"
end
