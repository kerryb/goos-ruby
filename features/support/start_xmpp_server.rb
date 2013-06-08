system "cd xmpp_server; vines start -d"

at_exit do
  system "cd xmpp_server; vines stop"
end
