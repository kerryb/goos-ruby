module DrivesApplication
  def sniper
    @sniper ||= ApplicationDriver.new
  end
end
World DrivesApplication
