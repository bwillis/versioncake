module VersionCake
  module Rack
    class Middleware

      def initialize(app)
        @app = app
        @version_service = VersionCake::VersionContextService.new(VersionCake.config)
      end

      def call(env)
        request = ::Rack::Request.new env
        if context = @version_service.create_context_from_request(request)
          env['versioncake.context'] = context
        end

        @app.call(env)
      end
    end
  end
end
