require "xmpp/xmpp_auction"
require "blather/client/client"

class XmppAuctionHouse
  def initialize username, password
    @connection = setup_xmpp_client username, password
    @connection.connect
  end

  def auction_for item_id
    auction = Xmpp::XmppAuction.new @connection, item_id
    @connection.register_handler(:ready) { auction.join }
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
