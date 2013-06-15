$:.unshift "lib"
require "main"
require "cucumber"
require "cucumber/rake/task"
require 'rspec/core/rake_task'

task :default => [:spec, :"xmpp_server:start", :"cucumber:ok", :"cucumber:wip", :"xmpp_server:stop", :success]

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

namespace :xmpp_server do
  task :start do
    system "cd vines; vines start -d"
  end

  task :stop do
    system "cd vines; vines stop"
  end
end

task :run => :"xmpp_server:start" do
  Main.main "sniper@localhost", "sniper", ""
  begin
    loop { sleep 1000 }
  rescue Interrupt
    Rake::Task[:"xmpp_server:stop"].execute
  end
end
