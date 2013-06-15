module AuctionMessageTranslator
  def self.for listener
    ->(message) {
      event = unpack_event_from message
      case event["Event"]
      when "PRICE"
        listener.current_price Integer(event["CurrentPrice"]), Integer(event["Increment"])
      when "CLOSE"
        listener.auction_closed
      end
    }
  end

  def self.unpack_event_from message
    Hash[*message.body.split(";").flat_map {|a| a.split ":" }.map(&:strip)]
  end
  private_class_method :unpack_event_from
end
