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

  def sequence(seq, source=nil)
    s = mock!
    stub(s).sequence{ seq }
    stub(s).source{ source } if source
    stub(s).entry_type{ :sequence }
    s
  end

  def unresolved(seq)
    s = mock!
    stub(s).sequence{ seq }
    stub(s).entry_type{ :unresolved }
    s
  end

end
