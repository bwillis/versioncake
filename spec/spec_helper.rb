require 'bundler'
Bundler.require

require 'renderversion'
require 'rspec'

Dir[File.expand_path(File.join(File.dirname(__FILE__), "support/**/*.rb"))].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :mocha
end

FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
FIXTURES = Pathname.new(FIXTURE_LOAD_PATH)
