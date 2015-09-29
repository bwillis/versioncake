require 'versioncake/strategies/extraction_strategy'
require 'versioncake/strategies/http_accept_parameter_strategy'
require 'versioncake/strategies/http_header_strategy'
require 'versioncake/strategies/query_parameter_strategy'
require 'versioncake/strategies/path_parameter_strategy'
require 'versioncake/strategies/request_parameter_strategy'
require 'versioncake/strategies/custom_strategy'

require 'versioncake/response_strategy/base'
require 'versioncake/response_strategy/http_header_strategy'
require 'versioncake/response_strategy/http_content_type_strategy'

require 'versioncake/exceptions'
require 'versioncake/configuration'
require 'versioncake/versioned_request'
require 'versioncake/version_checker'
require 'versioncake/version_context'
require 'versioncake/version_context_service'
require 'versioncake/versioned_response_service'
require 'versioncake/versioned_resource'
require 'versioncake/rack/middleware'
require 'versioncake/cli'
require 'versioncake/test_helpers'

if defined?(Rails)
  require 'versioncake/controller_additions'
  require 'versioncake/view_additions'
  require 'versioncake/engine'
end

module VersionCake

  mattr_accessor :config

  self.config = VersionCake::Configuration.new

  # Yield self on setup for nice config blocks
  def self.setup
    yield self.config
  end
end