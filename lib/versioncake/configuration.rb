require 'active_support/core_ext/module/attribute_accessors.rb'

module VersionCake
  module Configuration

    SUPPORTED_VERSIONS_DEFAULT = (1..10)

    mattr_accessor :supported_version_numbers
    self.supported_version_numbers = SUPPORTED_VERSIONS_DEFAULT

    # this does not look like configuration
    mattr_accessor :extraction_strategies
    self.extraction_strategies = [VersionCake::QueryParameterStrategy.new]

    def self.extract_version(request)
      version = nil
      extraction_strategies.each do |strategy|
        version = strategy.extract(request)
        break unless version.nil?
      end
      version
    end

    # this looks like configuration
    def self.extraction_strategy=(val)
      @@extraction_strategies.clear
      Array.wrap(val).each do |configured_strategy|
        @@extraction_strategies << VersionCake::ExtractionStrategy.lookup(configured_strategy)
      end
    end

    # this looks like configuration
    def self.supported_version_numbers=(val)
      @@supported_version_numbers = val.respond_to?(:to_a) ? val.to_a : Array.wrap(val)
      @@supported_version_numbers.sort!.reverse!
    end

    # this looks like configuration
    def self.supported_versions(requested_version_number=nil)
      supported_version_numbers.collect do |supported_version_number|
        if requested_version_number.nil? || supported_version_number <= requested_version_number
          :"v#{supported_version_number}"
        end
      end
    end

    # this looks like configuration
    def self.supports_version?(version)
      supported_version_numbers.include? version
    end

    # this looks like configuration
    def self.latest_version
      supported_version_numbers.first
    end

  end
end