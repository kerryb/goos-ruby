require "xmpp/xmpp_auction"
require "blather/client/client"

module Xmpp
  class XmppAuctionHouse
    def initialize username, password
      @connection = setup_xmpp_client username, password
      @connection.register_handler(:ready) { @ready = true }
      @connection.connect
      sleep 0.1 until @ready
    end

    def auction_for item_id
      auction = Xmpp::XmppAuction.new @connection, item_id
      auction
    end

    def disconnect
      @connection.close
    end

    private

    def setup_xmpp_client username, passsword
      Blather::Client.setup username, passsword
    end
  end
end
