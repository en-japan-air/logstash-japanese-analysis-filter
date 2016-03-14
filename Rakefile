require "logstash/devutils/rake"

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :prepare

task :prepare do
  require 'lock_jar'

  # get jarfile relative the gem dir
  lockfile = File.expand_path("../Jarfile.lock", __FILE__)

  LockJar.install(lockfile)
end
