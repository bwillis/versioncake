require 'action_controller'

module VersionCake
  module ControllerAdditions
    extend ActiveSupport::Concern

    # The explicit version requested by a client, this may not
    # be the rendered version and may also be nil.
    attr_accessor :requested_version

    # A boolean check to determine if the requested version is deprecated.
    attr_accessor :is_older_version

    # A boolean check to determine if the latest version is requested.
    attr_accessor :is_latest_version

    # A boolean check to determine if the requested version is newer than any supported version.
    attr_accessor :is_newer_version

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
      @is_older_version         = versioned_request.is_older_version
      @is_latest_version        = versioned_request.is_latest_version
      @is_newer_version         = versioned_request.is_newer_version

      set_response_header

      raise ActionController::RoutingError.new("Version is deprecated") if versioned_request.is_older_version
      raise ActionController::RoutingError.new("No route match for version") if versioned_request.is_newer_version

      @_lookup_context.versions = versioned_request.supported_versions
    end

    private

    # Adds a header field in the response with a name that corresponds
    # to the value of the configuration's response_header_key variable.
    # The value of the header field is "true" if the requested version
    # is supported and "false" when it is not supported.
    #
    # The header is only added to the response when the configuration's
    # response_header_key variable is defined.
    #
    # @return No explicit return, but sets a header in the response
    def set_response_header
      header_key = VersionCake::Railtie.config.versioncake.response_header_key
      is_supported_version = !(@is_older_version || @is_newer_version)
      headers[header_key] = is_supported_version.to_s if header_key
    end
  end
end

ActionController::Base.send(:include, VersionCake::ControllerAdditions)