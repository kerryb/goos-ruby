require "support/roles/sniper_listener"
require "ui_thread_sniper_listener"

describe UiThreadSniperListener do
  let(:delegate) { double :delegate, sniper_state_changed: true }
  subject { UiThreadSniperListener.new delegate }

  it_behaves_like "a sniper listener"

  describe "when the sniper state changes" do
    class FakeEM
      def self.next_tick &block
        @@block = block
      end

      def self.tick
        @@block.call
      end
    end

    before { stub_const "EM", FakeEM }

    it "notifies its delegate on the next EventMachine tick" do
      state = double :state
      subject.sniper_state_changed state
      expect(delegate).to_not have_received :sniper_state_changed
      EM.tick
      expect(delegate).to have_received(:sniper_state_changed).with state
    end
  end
end
