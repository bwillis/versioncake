require 'active_support/core_ext/module/attribute_accessors.rb'

module VersionCake
  module Configuration

    SUPPORTED_VERSIONS_DEFAULT = (1..10)

    mattr_accessor :supported_version_numbers
    self.supported_version_numbers = SUPPORTED_VERSIONS_DEFAULT

    mattr_accessor :extraction_strategies
    self.extraction_strategies = [VersionCake::QueryParameterStrategy.new]

    mattr_accessor :default_version
    self.default_version = nil

    def self.extraction_strategy=(val)
      @@extraction_strategies.clear
      Array.wrap(val).each do |configured_strategy|
        @@extraction_strategies << VersionCake::ExtractionStrategy.lookup(configured_strategy)
      end
    end

    def self.supported_version_numbers=(val)
      @@supported_version_numbers = val.respond_to?(:to_a) ? val.to_a : Array.wrap(val)
      @@supported_version_numbers.sort!.reverse!
    end

    def self.supported_versions(requested_version_number=nil)
      supported_version_numbers.collect do |supported_version_number|
        if requested_version_number.nil? || supported_version_number <= requested_version_number
          :"v#{supported_version_number}"
        end
      end
    end

    def self.supports_version?(version)
      supported_version_numbers.include? version
    end

    def self.latest_version
      supported_version_numbers.first
    end

  end
end