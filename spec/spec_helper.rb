# Require our library
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'simms'))

RSpec.configure do |config|
  #config.add_formatter 'documentation'
  config.color = true
  config.backtrace_clean_patterns = [/rspec/]
end

