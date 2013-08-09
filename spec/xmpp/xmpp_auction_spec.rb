require "xmpp/xmpp_auction"
require "support/roles/auction"

describe Xmpp::XmppAuction do
  subject { Xmpp::XmppAuction.new connection, "item-123" }
  let(:connection) {
    double :connection, register_handler: true, jid: double(stripped: "sniper")
  }

  it_behaves_like "an auction"
end
