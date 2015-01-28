module VersionCake
  module Rack
    class Middleware

      def initialize(app)
        @app = app
        @versioned_resources = VersionCake.config.versioned_resources
        @default_version = VersionCake.config.missing_version
        @strategies = VersionCake.config.extraction_strategies
      end

      def call(env)
        raw_request = ::Rack::Request.new env
        resource = @versioned_resources.find { |resource| resource.uri.match raw_request.path }

        if resource
          request = VersionCake::VersionedRequest.new(raw_request, @strategies, @default_version)
          request.execute
          checker = VersionCake::VersionChecker.new(resource, request)
          checker.execute

          env['versioncake.context'] = VersionCake::VersionContext.new(request.version, resource, checker.result)
        end

        @app.call(env)
      end
    end
  end
end
