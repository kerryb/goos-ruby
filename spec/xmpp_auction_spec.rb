require "support/roles/auction"

describe XmppAuction do
  subject { XmppAuction.new double(:client), "item-123" }
  it_behaves_like "an auction"
end
