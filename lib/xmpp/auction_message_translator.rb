module Xmpp
  class AuctionMessageTranslator
    def initialize sniper_id, listener, failure_reporter
      @sniper_id, @listener, @failure_reporter = sniper_id, listener, failure_reporter
    end

    def handle_message message
      event = AuctionEvent.from message
      case event.type
      when "PRICE"
        @listener.current_price event.current_price, event.increment, event.is_from?(@sniper_id)
      when "CLOSE"
        @listener.auction_closed
      end
    rescue => e
      @failure_reporter.cannot_translate_message @sniper_id, message.body, e
      @listener.auction_failed
    end

    class AuctionEvent
      class MissingValueException < RuntimeError; end
      class BadlyFormedMessageException < RuntimeError; end

      def initialize fields
        @fields = fields
      end

      def self.from message
        new fields_in(message.body)
      end

      def type
        field "Event"
      end

      def current_price
        Integer(field "CurrentPrice")
      end

      def increment
        Integer(field "Increment")
      end

      def is_from? sniper_id
        field("Bidder") == sniper_id ? :from_sniper : :from_other_bidder
      end

      private

      def self.fields_in body
        fields = body.split ";"
        name_value_pairs = fields.flat_map {|a| a.split ":" }.map(&:strip)
        Hash[*name_value_pairs]
      rescue
        raise BadlyFormedMessageException.new body
      end
      private_class_method :fields_in

      def field key
        @fields.fetch(key) { raise MissingValueException.new(key) }
      end
    end
  end
end
