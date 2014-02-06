module VersionCake
  class VersionedRequest
    attr_reader :version, :extracted_version, :is_latest_version

    def initialize(request, version_override=nil)
      @version = version_override || extract_version(request)
      @is_latest_version = @version == config.latest_version
    end

    def supported_versions
      config.supported_versions(@version)
    end

    private

    def config
      VersionCake::Railtie.config.versioncake
    end

    def apply_strategies(request)
      version = nil
      config.extraction_strategies.each do |strategy|
        version = strategy.extract(request)
        break unless version.nil?
      end
      version
    end

    def extract_version(request)
      @extracted_version = apply_strategies(request)
      if @extracted_version.nil?
        @version = config.default_version || config.latest_version
      elsif config.supports_version? @extracted_version
        @version = @extracted_version
      elsif @extracted_version > config.latest_version
        raise ActionController::RoutingError.new("No route match for version")
      else
        raise ActionController::RoutingError.new("Version is deprecated")
      end
    end
  end
end