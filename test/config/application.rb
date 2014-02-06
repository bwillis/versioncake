require "action_controller/railtie"
require "active_support/railtie"

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module RendersTest
  class Application < Rails::Application

    config.secret_key_base = "secret"
    config.eager_load = false

    config.active_support.deprecation = :stderr

    config.versioncake.supported_version_numbers = (1..3)
    config.versioncake.extraction_strategy = [:http_header, :http_accept_parameter, :query_parameter, :request_parameter]
  end
end
