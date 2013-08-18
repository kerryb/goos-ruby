#require "blather/client/client"
require "xmpp/chat"

describe Xmpp::Chat do
  subject { Xmpp::Chat.new connection, address }
  let(:fake_connection_class) {
    Class.new do
      def register_handler type, guard, &handler
        fail "Unexpected registration for #{type} events" unless type == :message
        @guard, @handler = guard, handler
      end

      def receive_message message
        @handler.call message if @guard.(message)
      end
    end
  }
  let(:connection) { fake_connection_class.new }
  let(:address) { "someone" }
  let(:listener) { double :listener, handle_message: true }
  let(:our_message) { double :our_message, from: double(node: address) }
  let(:another_message) { double :another_message, from: double(node: "someone-else") }

  describe "#add_message_listener" do
    it "registers a handler which passes received mesages to the listener" do
      subject.add_message_listener listener
      connection.receive_message our_message
      expect(listener).to have_received(:handle_message).with our_message
    end

    it "does not pass on received mesages for a different item" do
      subject.add_message_listener listener
      connection.receive_message another_message
      expect(listener).to_not have_received(:handle_message)
    end
  end

  describe "#remove_message_listener" do
    it "stops passing messages to the listener" do
      subject.add_message_listener listener
      subject.remove_message_listener listener
      connection.receive_message our_message
      expect(listener).to_not have_received(:handle_message)
    end
  end
end
