require 'active_support/core_ext/module/attribute_accessors.rb'
require 'active_support/core_ext/array/wrap.rb'

module VersionCake
  class Configuration

    SUPPORTED_VERSIONS_DEFAULT = (1..10)
    VERSION_KEY_DEFAULT = 'api_version'

    attr_reader :extraction_strategies, :supported_version_numbers
    attr_accessor :default_version, :version_key

    def initialize
      @version_key                   = VERSION_KEY_DEFAULT
      self.supported_version_numbers = SUPPORTED_VERSIONS_DEFAULT
      self.extraction_strategy       = :query_parameter
    end

    def extraction_strategy=(val)
      @extraction_strategies = []
      Array.wrap(val).each do |configured_strategy|
        @extraction_strategies << VersionCake::ExtractionStrategy.lookup(configured_strategy)
      end
    end

    def supported_version_numbers=(val)
      @supported_version_numbers = val.respond_to?(:to_a) ? val.to_a : Array.wrap(val)
      @supported_version_numbers.sort!.reverse!
    end

    def supported_versions(requested_version_number=nil)
      @supported_version_numbers.collect do |supported_version_number|
        if requested_version_number.nil? || supported_version_number <= requested_version_number
          :"v#{supported_version_number}"
        end
      end
    end

    def supports_version?(version)
      @supported_version_numbers.include? version
    end

    def latest_version
      @supported_version_numbers.first
    end

  end
end