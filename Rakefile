$:.unshift "lib"
require "sniper"
require "cucumber"
require "cucumber/rake/task"

task :default => :features

Cucumber::Rake::Task.new :features

task :run do
  Sniper.new "sniper@localhost", "sniper", ""
  loop { sleep 1000 }
end
