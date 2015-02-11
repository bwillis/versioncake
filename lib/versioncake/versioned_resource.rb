module VersionCake
  class VersionedResource
    attr_reader :uri, :supported_versions, :deprecated_versions, :obsolete_versions

    def initialize(uri, obsolete_versions, deprecated_versions, supported_versions)
      @uri, @supported_versions, @deprecated_versions, @obsolete_versions =
        uri, supported_versions, deprecated_versions, obsolete_versions
    end

    def latest_version
      @supported_versions.last
    end
  end
end
