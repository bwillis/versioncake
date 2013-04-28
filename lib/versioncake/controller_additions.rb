require 'action_controller'

module VersionCake
  module ControllerAdditions
    extend ActiveSupport::Concern

    attr_accessor :requested_version, :is_latest_version, :derived_version

    included do
      prepend_before_filter :set_version
    end

    protected
    def set_version(override_version=nil)
      versioned_request         = VersionCake::VersionedRequest.new(request, override_version)
      @requested_version        = versioned_request.extracted_version
      @derived_version          = versioned_request.version
      @_lookup_context.versions = versioned_request.supported_versions
      @is_latest_version        = versioned_request.is_latest_version
    end
  end
end

ActionController::Base.send(:include, VersionCake::ControllerAdditions)