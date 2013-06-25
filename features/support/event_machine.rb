Before do
  @em_thread = Thread.new { EM.run }
  sleep 0.01 until EM.reactor_running?
end

After do
  EM.stop_event_loop if EM.reactor_running?
  @em_thread.join
end
