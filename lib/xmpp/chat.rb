module Xmpp
  class Chat
    def initialize connection, address
      @connection, @address = connection, address
    end

    def add_message_listener listener
      @connection.register_handler :message,
        ->(message) { message.from.node == @address } do |message|
        listener.handle_message message
      end
    end
  end
end
