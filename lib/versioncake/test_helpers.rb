module VersionCake
  module TestHelpers
    def set_request_version(version_number, version_status=:supported, supported_versions=[version_number])
      if version_number.is_a? Symbol
        version_status = version_number
        if version_status == :supported
          version_number = 1
        else
          version_number = 666
        end
      end

      @request.env['versioncake.context'] = VersionCake::VersionContext.new(
          version_number,
          instance_double('VersionedResource', latest_version: supported_versions.last, supported_versions: supported_versions),
          version_status
      )
    end
  end
end