require "xmpp_auction"
require "support/roles/auction"

describe XmppAuction do
  subject { XmppAuction.new double(:chat) }
  it_behaves_like "an auction"
end
