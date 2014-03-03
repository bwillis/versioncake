require 'action_controller'

module VersionCake
  module ControllerAdditions
    extend ActiveSupport::Concern

    # The explicit version requested by a client, this may not
    # be the rendered version and may also be nil.
    attr_accessor :requested_version

    # A boolean check to determine if the latest version is requested.
    attr_accessor :is_latest_version

    # The requested version by a client or if it's nil the latest or default
    # version configured.
    attr_accessor :derived_version

    # set_version is the prepend filter that will determine the version of the
    # requests.
    included do
      prepend_before_filter :set_version
    end

    protected

    # Sets the version of the request as well as several accessor variables.
    #
    # @param override_version a version number to use instead of the one extracted
    #     from the request
    #
    # @return No explicit return, but several attributes are exposed
    def set_version(override_version=nil)
      versioned_request         = VersionCake::VersionedRequest.new(request, override_version)
      @requested_version        = versioned_request.extracted_version
      @derived_version          = versioned_request.version
      @is_latest_version        = versioned_request.is_latest_version?
      if !versioned_request.is_version_supported?
        raise UnsupportedVersionError.new('Unsupported version error')
      end
      @_lookup_context.versions = versioned_request.supported_versions
    end
  end
end

ActionController::Base.send(:include, VersionCake::ControllerAdditions)