# GOOS in Ruby

My attempt at implementing the auction sniper example from part II of *Growing
Object-Oriented Software, Guided By Tests*. I've tagged the repository at the
end of each chapter (currently I've only done chapters 10 and 11).

## Tools

### XMPP

I'm using the [Vines](http://www.getvines.org/) XMPP server (installed as a gem and
started and stopped automatically by the tests).

For the client I'm using [Blather](https://github.com/adhearsion/blather),
which runs in [EventMachine](http://rubyeventmachine.com/) so has to be started
in its own thread to avoid blocking the rest of the application.

### GUI

I considered using Swing to keep close to the book, but that would have
restricted the app to only running on JRuby. I tried Tk and Qt, but couldn't
figure out any particularly easy way of testing them, and they didn't seem to
take particularly well to being run in separate threads.

In the end, I settled on [GTK+](http://www.gtk.org/). The default Mac version
runs in X Windows and is fairly ugly, but it exposes all its widgets cleanly so
I can poke them and assert things about them from the end-to-end tests.

### Testing

I'm using [Cucumber](http://cukes.info/) for end-to-end/acceptance tests, and
[RSpec](http://rspec.info/) for unit tests.

To test the UI, I have it start up a
[DRb](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/drb/rdoc/DRb.html) server
exposing the main window, and connect to that from the tests.
