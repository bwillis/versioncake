require 'active_support/core_ext/module/attribute_accessors.rb'
require 'active_support/core_ext/array/wrap.rb'

module VersionCake
  class Configuration
    VERSION_KEY_DEFAULT = 'api_version'

    attr_reader :extraction_strategies, :response_strategies,
      :versioned_resources, :default_version, :missing_version_use_unversioned_template
    attr_accessor :missing_version, :version_key, :rails_view_versioning

    def initialize
      @versioned_resources           = []
      @version_key                   = VERSION_KEY_DEFAULT
      @rails_view_versioning         = true
      @missing_version_use_unversioned_template = true
      @default_version = nil
      self.extraction_strategy       = [
          :http_accept_parameter,
          :http_header,
          :request_parameter,
          :path_parameter,
          :query_parameter
      ]
      self.response_strategy         = []
    end

    def missing_version=(val)
      @missing_version = val
      if @missing_version == :unversioned_template
        @missing_version_use_unversioned_template = true
        @default_version = nil
      else
        @missing_version_use_unversioned_template = false
        @default_version = val
      end
    end

    def extraction_strategy=(val)
      @extraction_strategies = []
      Array.wrap(val).each do |configured_strategy|
        @extraction_strategies << VersionCake::ExtractionStrategy.lookup(configured_strategy)
      end
    end

    def response_strategy=(val)
      @response_strategies = []
      Array.wrap(val).each do |configured_strategy|
        @response_strategies << VersionCake::ResponseStrategy::Base.lookup(configured_strategy)
      end
    end

    def resources
      builder = ResourceBuilder.new
      yield builder
      @versioned_resources = builder.resources
    end
  end

  class ResourceBuilder
    attr_reader :resources
    def initialize
      @resources = []
    end
    def resource(regex, obsolete, unsupported, supported)
      @resources << VersionCake::VersionedResource.new(regex, obsolete, unsupported, supported)
    end
  end
end
