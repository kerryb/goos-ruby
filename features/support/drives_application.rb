module DrivesApplication
  def sniper
    @sniper ||= ApplicationRunner.new
  end
end
World DrivesApplication

After do
  sniper.stop if sniper
end
