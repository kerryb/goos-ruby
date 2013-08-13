# GOOS in Ruby

My attempt at implementing the auction sniper example from part II of
[*Growing Object-Oriented Software, Guided By Tests*](http://www.growing-object-oriented-software.com/).
I've tagged the repository at the end of each chapter:

* [Chapter 10](https://github.com/kerryb/goos-ruby/tree/chapter-10)
* [Chapter 11](https://github.com/kerryb/goos-ruby/tree/chapter-11)
* [Chapter 12](https://github.com/kerryb/goos-ruby/tree/chapter-12)
* [Chapter 13](https://github.com/kerryb/goos-ruby/tree/chapter-13)
* [Chapter 14](https://github.com/kerryb/goos-ruby/tree/chapter-14)
* [Chapter 15](https://github.com/kerryb/goos-ruby/tree/chapter-15)
* [Chapter 16](https://github.com/kerryb/goos-ruby/tree/chapter-16)
* [Chapter 17](https://github.com/kerryb/goos-ruby/tree/chapter-17)
* [Chapter 18](https://github.com/kerryb/goos-ruby/tree/chapter-18)

There are links to a few other people's implementations
[on the GOOS site](http://www.growing-object-oriented-software.com/code.html),
including
[another one in Ruby](https://github.com/marick/growing-oo-software-in-ruby)
from Brian Marick.

## Tools

### Ruby

Tested using the version in `.ruby-version`. I started in 1.9.3 then switched
to 2.0.0, but as far as I know anything 1.9 or above ought to work.

### XMPP

The [Vines](http://www.getvines.org/) XMPP server is started and stopped
automatically by the tests.

For the client I tried [xmpp4r](http://home.gna.org/xmpp4r/) and
[xmp4r-simple](https://github.com/blaine/xmpp4r-simple), but couldn't get
either of them to work properly, so ended up with
[Blather](https://github.com/adhearsion/blather).  This runs in
[EventMachine](http://rubyeventmachine.com/) so has to be started in its own
thread to avoid blocking the rest of the application.

### GUI

I considered using Swing to keep close to the book, but that would have
restricted the app to only running on JRuby. I tried Tk and Qt, but couldn't
figure out any easy way of testing them, and they didn't seem to take
particularly well to being run in separate threads.

In the end, I settled on [GTK+](http://www.gtk.org/). The default Mac version
runs in X Windows and is fairly ugly, but it exposes all its widgets cleanly so
I can poke them and assert things about them from the end-to-end tests.

### Testing

I'm using [Cucumber](http://cukes.info/) for end-to-end/acceptance tests, and
[RSpec](http://rspec.info/) (version 2.14.0rc1, so I can use spies) for unit
tests.

To test the UI, I'm just calling methods directly on the main Gtk::Window
object (which still runs as normal and can be seen on the screen as the tests
run).

## Notes

### Interfaces and roles

I'm trying to stick pretty closely to the design used in the book. However, the
book makes heavy use of Java interfaces, which don't exist in Ruby. As a
compromise between explicit interfaces and pure duck-typing, I've created
[specs for the
interfaces](https://github.com/kerryb/goos-ruby/tree/master/spec/support/roles),
which simply check that anything acting as that role implements the correct
methods.

One exception (for now, at least) is UserRequestListener from chapter 16.
That's currently just implemented by having Main#add_user_request_listener_for
take a block which is registered as the listener, and only handles join
requests.

### AuctionMessageTranslator

Unlike Smack, Blather works at the individual message level, rather than
modelling persistent chats. To ensure messages only get sent to the appropriate
listener for each auction, I've added a guard on the message originator when
registering the listener.

### Checking state with doubles in specs

RSpec doesn't have the "states" feature from JMock, but it's easy enough to
replicate by executing a block when the stubbed methods are called, and setting
or checking an instance variable as appropriate.

### Enums

There are no enums in Ruby, so classes like `Column` and `SniperState` are
implemented as (rather inelegant) collections of constants.

### Bugs

There seems to be a race condition on startup – every so often a feature will
fail because (I think) the auction server never receives a join request from
the sniper.
