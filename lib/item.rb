Item = Struct.new :identifier, :stop_price do
  def allows_bid? bid
    bid <= stop_price
  end
end
