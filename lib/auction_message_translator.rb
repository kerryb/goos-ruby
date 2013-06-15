module AuctionMessageTranslator
  def self.for listener
    ->(message) { listener.auction_closed }
  end
end
