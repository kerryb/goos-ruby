module RunsApplication
  def sniper
    @sniper ||= ApplicationRunner.new
  end
end
World RunsApplication

After { sniper.stop if @sniper }
