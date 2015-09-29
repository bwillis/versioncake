module VersionCake
  module Rack
    class Middleware

      def initialize(app, config=VersionCake.config)
        @app = app
        @version_service = VersionCake::VersionContextService.new(config)
        @response_service = VersionCake::VersionedResponseService.new(config)
        @config = config
      end

      def call(env)
        request = ::Rack::Request.new env
        if context = @version_service.create_context_from_request(request)
          env['versioncake.context'] = context

          status, headers, response = @app.call(env)

          @response_service.inject_version(context, status, headers, response)

          [status, headers, response]
        else
          @app.call(env)
        end
      end
    end
  end
end
