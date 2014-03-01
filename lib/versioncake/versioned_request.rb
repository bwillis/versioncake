module VersionCake
  class VersionedRequest
    attr_reader :version, :extracted_version

    def initialize(request, version_override=nil)
      derive_version(request, version_override)
    end

    def supported_versions
      config.supported_versions(@version)
    end

    def is_latest_version?
      @version == config.latest_version
    end

    def is_version_supported?
      config.supports_version? @version
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

    def derive_version(request, version_override)
      if version_override
        @version = version_override
      else
        @extracted_version = apply_strategies(request)
        @version = @extracted_version || config.default_version || config.latest_version
      end
    end
  end
end