module DrivesApplication
  def sniper
    @sniper ||= ApplicationRunner.new
  end
end
World DrivesApplication

After { sniper.stop if @sniper }
