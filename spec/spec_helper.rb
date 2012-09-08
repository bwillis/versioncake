require 'bundler'
Bundler.require

require 'renderversion'
require 'rspec'
require 'rails/all'
require 'rspec/rails'
require 'config/application'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV["RAILS_ENV"] ||= 'test'

root = File.expand_path(File.dirname(__FILE__))

# Initialize the application
RendersTest::Application.initialize!

RSpec.configure do |config|
  config.mock_with :mocha
end

FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
FIXTURES = Pathname.new(FIXTURE_LOAD_PATH)

Dir.glob(File.dirname(__FILE__) + "/app/controllers/**/*").each{|f| require(f) if File.file?(f)}