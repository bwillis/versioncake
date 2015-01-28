module VersionCake
  class VersionContext
    attr_reader :version, :resource, :result

    def initialize(version, resource, result)
      @version, @resource, @result = version, resource, result
    end

    # A boolean check to determine if the latest version is requested.
    def is_latest_version?
      @version == @resource.latest_version
    end
  end
end