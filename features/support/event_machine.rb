Before do
  @em_thread = Thread.new { EM.run }
end

After do
  EM.stop_event_loop
  @em_thread.join
end
