$:.unshift "lib"
require "main"
require "cucumber"
require "cucumber/rake/task"
require 'rspec/core/rake_task'

task :default => [:spec, :"cucumber:ok", :"cucumber:wip", :success]

RSpec::Core::RakeTask.new :spec

namespace :cucumber do
  Cucumber::Rake::Task.new(:ok) do |t|
    t.cucumber_opts = "--tags ~@wip"
  end

  Cucumber::Rake::Task.new(:wip) do |t|
    t.cucumber_opts = "--wip --tags @wip"
  end
end

task :success do
  red    = "\e[31m"
  yellow = "\e[33m"
  green  = "\e[32m"
  blue   = "\e[34m"
  purple = "\e[35m"
  bold   = "\e[1m"
  normal = "\e[0m"
  puts "", "#{bold}#{red}*#{yellow}*#{green}*#{blue}*#{purple}* #{green} ALL TESTS PASSED #{purple}*#{blue}*#{green}*#{yellow}*#{red}*#{normal}"
end

task :run do
  Thread.new { EM.run }
  Main.main "sniper@localhost", "sniper", ""
end
