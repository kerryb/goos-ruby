# GOOS in Ruby

My attempt at implementing the auction sniper example from part II of *Growing
Object-Oriented Software, Guided By Tests*.

Uses the [Vines](http://www.getvines.org/) XMPP server (installed as a gem and
started from the rakefile), and GTK+ for the GUI, rather than Swing (I tried Tk
and Qt, but couldn't figure out any way of testing them).

## Prerequisites

* [Gtk](http://www.gtk.org/)
* Ruby 1.9.3 or thereabouts (tested with the one in `.ruby-version`)
