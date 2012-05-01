$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'heredoc_unindent'
require 'genomer-plugin-summary'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require File.expand_path(f)
end

RSpec.configure do |config|
  config.mock_with :rr
end
