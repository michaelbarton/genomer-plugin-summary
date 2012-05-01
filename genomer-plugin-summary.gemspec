# -*- encoding: utf-8 -*-
require File.expand_path('../lib/genomer-plugin-summary/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Barton"]
  gem.email         = ["mail@michaelbarton.me.uk"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "genomer-plugin-summary"
  gem.require_paths = ["lib"]
  gem.version       = GenomerPluginSummary::VERSION

  gem.add_development_dependency 'rake', '~> 0.9.0'

  gem.add_development_dependency 'rspec',                   '~> 2.9.0'
  gem.add_development_dependency "rr",                      "~> 1.0.4"
  gem.add_development_dependency "scaffolder-test-helpers", "~> 0.4.0"

  gem.add_development_dependency 'cucumber', '~> 1.1.9'
  gem.add_development_dependency 'aruba',    '~> 0.4.11'

end
