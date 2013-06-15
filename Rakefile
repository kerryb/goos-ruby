$:.unshift "lib"
require "main"
require "cucumber"
require "cucumber/rake/task"
require 'rspec/core/rake_task'

task :default => [:spec, :features]

RSpec::Core::RakeTask.new :spec

Cucumber::Rake::Task.new :features

task :run do
  Main.main "sniper@localhost", "sniper", ""
  loop { sleep 1000 }
end
