module VersionCake
  module TestHelpers
    # Test helper the mimics the middleware because we do not
    # have middleware during tests.
    def set_request_version(resource, version)
      service = VersionCake::VersionContextService.new(VersionCake.config)
      @request.env['versioncake.context'] = service.create_context resource, version
    end

    def set_version_context(status, resource=nil, version=nil)
      @request.env['versioncake.context'] = VersionCake::VersionContext.new(version, resource, status)
    end
  end
end