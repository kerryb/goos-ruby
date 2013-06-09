$:.unshift "lib"
require "sniper"
require "cucumber"
require "cucumber/rake/task"

task :default => :features

Cucumber::Rake::Task.new :features

task :run do
  app = Sniper.new "sniper@localhost", "sniper", ""
  Tk.mainloop
end
