source 'https://rubygems.org'
gemspec

@@check ||= at_exit do
  require 'lock_jar/bundler'
  LockJar::Bundler.lock!(::Bundler)
end