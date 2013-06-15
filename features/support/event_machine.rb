Before do
  @em_thread = Thread.new { EM.run } unless EM.reactor_running?
end
