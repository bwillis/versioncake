require 'bundler'
Bundler.require

require 'renderversion'

ENV["RAILS_ENV"] = 'test'

require 'rails/all'
require 'rails/test_help'
require 'test/unit'


require File.expand_path('../config/application', __FILE__)

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

root = File.expand_path(File.dirname(__FILE__))

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

RendersTest::Application.initialize!

Dir.glob(File.dirname(__FILE__) + "/app/controllers/**/*").each{|f| require(f) if File.file?(f)}