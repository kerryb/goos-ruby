module AuctionMessageTranslator
  def self.for listener
    ->(message) {
      event = AuctionEvent.from message
      case event.type
      when "PRICE"
        listener.current_price event.current_price, event.increment
      when "CLOSE"
        listener.auction_closed
      end
    }
  end

  class AuctionEvent
    def initialize fields
      @fields = fields
    end

    def self.from message
      new fields_in(message.body)
    end

    def type
      @fields.fetch "Event"
    end

    def current_price
      Integer(@fields.fetch "CurrentPrice")
    end

    def increment
      Integer(@fields.fetch "Increment")
    end

    private

    def self.fields_in body
      fields = body.split ";"
      name_value_pairs = fields.flat_map {|a| a.split ":" }.map(&:strip)
      Hash[*name_value_pairs]
    end
    private_class_method :fields_in
  end
end
