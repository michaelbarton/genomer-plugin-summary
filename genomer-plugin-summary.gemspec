# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'genomer-plugin-summary/version'

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

  gem.add_dependency "genomer",        ">= 0.0.4"
  gem.add_dependency "terminal-table", "~> 1.4.5"

  gem.add_development_dependency 'rake', '~> 0.9.0'

  gem.add_development_dependency 'rspec',                   '~> 2.9.0'
  gem.add_development_dependency "heredoc_unindent",        "~> 1.1.2"
  gem.add_development_dependency "rr",                      "~> 1.0.4"

  gem.add_development_dependency 'cucumber', '~> 1.1.9'
  gem.add_development_dependency 'aruba',    '~> 0.4.11'

end
