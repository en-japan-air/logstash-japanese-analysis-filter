Gem::Specification.new do |s|
  s.name = 'logstash-japanese-analysis-filter'
  s.version = '0.0.4'
  s.licenses = ['Apache License (2.0)']
  s.summary = "This example filter adds a new field japanese word analysis information"
  s.description = "This gem is a logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/plugin install gemname. This gem is not a stand-alone program"
  s.authors = ["en japan"]
  s.email = 'contact@en-japan.io'
  s.homepage = "https://github.com/en-japan/logstash-japanese-analysis-filter"
  s.require_paths = ["lib"]
  s.extensions = ["Rakefile"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT', 'Jarfile.lock']
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency 'lock_jar'
  s.add_runtime_dependency "logstash-core", ">= 2.0.0", "< 3.0.0"
  s.add_development_dependency 'logstash-devutils'

  s.add_runtime_dependency "natto"
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'awesome_print'
end
