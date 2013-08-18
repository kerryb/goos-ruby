module Xmpp
  class Chat
    def initialize connection, address
      @listeners = []
      @connection, @address = connection, address
      @connection.register_handler :message,
        ->(message) { message.from.node == @address } do |message|
        notify_listeners message
      end
    end

    def add_message_listener listener
      @listeners << listener
    end

    def remove_message_listener listener
      @listeners.delete listener
    end

    def send_message message
      EM.next_tick do
        @connection.write Blather::Stanza::Message.new("#{@address}@localhost", message)
      end
    end

    private

    def notify_listeners message
      @listeners.each {|l| l.handle_message message }
    end
  end
end
