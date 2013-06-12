$:.unshift "lib"
require "main"
require "cucumber"
require "cucumber/rake/task"

task :default => :features

Cucumber::Rake::Task.new :features

task :run do
  Main.main "sniper@localhost", "sniper", ""
  loop { sleep 1000 }
end
