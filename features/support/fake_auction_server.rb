require "blather/client/client"

class FakeAuctionServer
  attr_reader :item_id

  def initialize item_id
    @item_id = item_id
  end

  def start_selling_item
    @client = Blather::Client.setup auction_login, auction_password
    Thread.new do
      EM.run do
        @client.run
      end
    end
  end

  def close
  end

  private

  def auction_password
    "auction"
  end

  def auction_login
    "auction-#{item_id}@localhost"
  end
end
