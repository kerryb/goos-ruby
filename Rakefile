$:.unshift "lib"
require "main"
require "cucumber"
require "cucumber/rake/task"
require 'rspec/core/rake_task'

task :default => [:spec, :"cucumber:ok", :"cucumber:wip"]

RSpec::Core::RakeTask.new :spec

namespace :cucumber do
  Cucumber::Rake::Task.new(:ok) do |t|
    t.cucumber_opts = "--tags ~@wip"
  end

  Cucumber::Rake::Task.new(:wip) do |t|
    t.cucumber_opts = "--wip --tags @wip"
  end
end

task :run do
  Main.main "sniper@localhost", "sniper", ""
  loop { sleep 1000 }
end
