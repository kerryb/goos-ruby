require "sniper_portfolio"
require "support/roles/sniper_collector"

describe SniperPortfolio do
  it_behaves_like "a sniper collector"

  describe "when a sniper is added" do
    let(:sniper) { double :sniper }
    let(:listener) { double :listener, sniper_added: true }
    before { subject.add_portfolio_listener listener }

    it "notifies its listeners" do
      subject.add_sniper sniper
      expect(listener).to have_received(:sniper_added).with sniper
    end
  end
end
