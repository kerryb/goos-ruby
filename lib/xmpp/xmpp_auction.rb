require "logger"
require "blather/client/client"
require "announcer"
require "xmpp/chat"
require "xmpp/auction_message_translator"
require "xmpp/logging_xmpp_failure_reporter"

module Xmpp
  class XmppAuction
    JOIN_COMMAND_FORMAT = "SOLVersion: 1.1; Command: JOIN;"
    BID_COMMAND_FORMAT = "SOLVersion: 1.1; Command: BID; Price: %d;"

    def initialize connection, item
      @failure_reporter = Xmpp::LoggingXmppFailureReporter.new(
        Logger.new Xmpp::LoggingXmppFailureReporter::LOG_FILE_NAME)
      @auction_event_listeners = Announcer.new
      translator = translator_for connection
      @chat = Xmpp::Chat.new connection, auction_id_for(item)
      @chat.add_message_listener translator
      add_auction_event_listener chat_disconector_for(translator)
    end

    def add_auction_event_listener listener
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
      AuctionMessageTranslator.new connection.jid.stripped.to_s, @auction_event_listeners, @failure_reporter
    end

    def chat_disconector_for translator
      ChatDisconnector.new @chat, translator
    end

    def auction_id_for item
      "auction-#{item.identifier}"
    end

    def send_message message
      @chat.send_message message
    end

    class ChatDisconnector
      def initialize chat, translator
        @chat, @translator = chat, translator
      end

      def auction_failed
        @chat.remove_message_listener @translator
      end

      def auction_closed; end
      def current_price *; end
    end
  end
end
