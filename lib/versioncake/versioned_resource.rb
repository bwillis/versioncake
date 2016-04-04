module VersionCake
  class VersionedResource
    attr_reader :uri, :supported_versions, :deprecated_versions, :obsolete_versions

    def initialize(uri, obsolete_versions, deprecated_versions, supported_versions)
      @uri, @supported_versions, @deprecated_versions, @obsolete_versions =
        uri, supported_versions, deprecated_versions, obsolete_versions
    end

    def available_versions
      (@supported_versions.to_a + @deprecated_versions.to_a).sort
    end

    def latest_version
      available_versions.last
    end
  end
end
