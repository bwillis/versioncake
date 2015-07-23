require 'action_controller'

module VersionCake
  module ControllerAdditions
    extend ActiveSupport::Concern

    attr_accessor :versioned_request

    # set_version is the prepend filter that will determine the version of the
    # requests.
    included do
      prepend_before_action :set_version
    end

    # The explicit version requested by a client, this may not
    # be the rendered version and may also be nil.
    def requested_version
      versioned_request.extracted_version
    end

    # The requested version by a client or if it's nil the latest or default
    # version configured.
    def derived_version
      versioned_request.version
    end

    # A boolean check to determine if the latest version is requested.
    def is_latest_version
      versioned_request.is_latest_version?
    end

    protected

    # The current requests version information.
    def versioned_request
      set_version
      @versioned_request
    end

    # Sets the version of the request as well as several accessor variables.
    #
    # @param override_version a version number to use instead of the one extracted
    #     from the request
    #
    # @return No explicit return, but several attributes are exposed
    def set_version(override_version=nil)
      return if @versioned_request.present? && override_version.blank?
      @versioned_request = VersionCake::VersionedRequest.new(
          request,
          VersionCake::Railtie.config.versioncake,
          override_version
      )
      if !@versioned_request.is_version_supported?
        raise UnsupportedVersionError.new('Unsupported version error')
      end
      @_lookup_context.versions = @versioned_request.supported_versions
    end
  end
end

ActionController::Base.send(:include, VersionCake::ControllerAdditions)

if defined?(ActionController::API)
  ActionController::API.send(:include, VersionCake::ControllerAdditions)
end
