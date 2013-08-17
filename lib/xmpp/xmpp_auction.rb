require "blather/client/client"
require "xmpp/chat"
require "announcer"
require "xmpp/auction_message_translator"

module Xmpp
  class XmppAuction
    JOIN_COMMAND_FORMAT = "SOLVersion: 1.1; Command: JOIN;"
    BID_COMMAND_FORMAT = "SOLVersion: 1.1; Command: BID; Price: %d;"

    def initialize connection, item
      @auction_event_listeners = Announcer.new
      translator = translator_for connection
      @chat = Xmpp::Chat.new connection, auction_id_for(item)
      @chat.add_message_listener(
        translator
      )
    end

    def add_event_listener listener
      @auction_event_listeners.add_listener listener
    end

    def join
      send_message JOIN_COMMAND_FORMAT
    end

    def bid amount
      send_message(BID_COMMAND_FORMAT % amount)
    end

    private

    def translator_for connection
      AuctionMessageTranslator.new connection.jid.stripped.to_s, @auction_event_listeners
    end

    def auction_id_for item
      "auction-#{item.identifier}"
    end

    def send_message message
      @chat.send_message message
    end
  end
end
