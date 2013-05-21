require "action_controller/railtie"
require "active_support/railtie"

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module RendersTest
  class Application < Rails::Application

    config.secret_key_base = "secret"
    config.eager_load = false

    config.active_support.deprecation = :stderr
    config.view_versions = (1..3)
    config.view_version_extraction_strategy = :http_header
  end
end
