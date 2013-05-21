require 'coveralls'
Coveralls.wear!

require 'bundler'
Bundler.require

require 'versioncake'

ENV["RAILS_ENV"] = 'test'

require 'rails/test_help'
require 'test/unit'

require 'mocha/setup'

require File.expand_path('../config/application', __FILE__)

FIXTURE_LOAD_PATH = File.join(File.dirname(__FILE__), 'fixtures')
FIXTURES = Pathname.new(FIXTURE_LOAD_PATH)

RendersTest::Application.initialize!
