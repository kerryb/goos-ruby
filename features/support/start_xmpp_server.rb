system "cd vines; vines start -d"

at_exit do
  system "cd vines; vines stop"
end
