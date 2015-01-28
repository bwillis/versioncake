module VersionCake
  class VersionChecker
    attr_reader :result
    def initialize(request, resource)
      @request, @resource = resource, request
    end

    def execute
      @result = if @request.failed
        :version_invalid
      elsif @request.version.nil?
        :no_version
      elsif @resource.supported_versions.include? @request.version
        :supported
      elsif @resource.obsolete_versions.include? @request.version
        :obsolete
      elsif @resource.deprecated_versions.include? @request.version
        :deprecated
      elsif @request.version > @resource.supported_versions.last
        :version_too_high
      elsif @request.version < @resource.supported_versions.first
        :version_too_low
      else
        :unknown
      end
    end
  end
end
