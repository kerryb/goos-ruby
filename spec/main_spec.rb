require "support/roles/sniper_listener"
require "support/roles/auction"
require "main"

describe Main do
  subject { Main.new "item-123" }
  it_behaves_like "a sniper listener"

  describe "::XmppAuction" do
    subject { Main::XmppAuction.new double(:client), "item-123" }
    it_behaves_like "an auction"
  end
end
