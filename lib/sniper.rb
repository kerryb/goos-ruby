require "blather/client/client"

class Sniper
  attr_reader :status

  def initialize id, passsword, item_id
    @status = "Joining"
    @item_id = item_id

    @client = Blather::Client.setup id, passsword
    run
  end

  private

  attr_reader :client

  def run
    Thread.new do
      EM.run do
        client.run
      end
    end
  end
end
