require 'rails/all'
# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module RendersTest
  class Application < Rails::Application

    config.secret_key_base = "secret"
    config.eager_load = false

    config.active_support.deprecation = :stderr
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
