require 'action_controller'

module VersionCake
  module ControllerAdditions
    extend ActiveSupport::Concern

    # set_version is the prepend filter that will determine the version of the
    # requests.
    included do
      if respond_to? :prepend_before_action
        prepend_before_action :check_version!
      else
        prepend_before_filter :check_version!
      end
    end

    # The explicit version requested by a client, this may not
    # be the rendered version and may also be nil.
    def request_version
      @request_version ||= version_context.version
    end

    # A boolean check to determine if the latest version is requested.
    def is_latest_version?
      version_context.is_latest_version?
    end

    # A boolean check to determine if the version requested is deprecated.
    def is_deprecated_version?
      version_context.result == :deprecated
    end

    protected

    def version_context
      request.env['versioncake.context']
    end

    # Check the version of the request and raise errors when it's invalid. Additionally,
    # setup view versioning if configured.
    #
    # @param override_version a version number to use instead of the one extracted
    #     from the request
    #
    # @return No explicit return, but several attributes are exposed
    def check_version!(override_version=nil)
      return unless version_context
      
      case version_context.result
        when :version_invalid, :version_too_high, :version_too_low, :unknown
          raise UnsupportedVersionError.new('Unsupported version error')
        when :obsolete
          raise ObsoleteVersionError.new('The version given is obsolete')
        when :no_version
          raise MissingVersionError.new('No version was given')
      end

      if VersionCake.config.rails_view_versioning
        @_lookup_context.versions = version_context.supported_versions.map { |n| :"v#{n}" }
      end
    end

    def set_version(version)
      @request_version = version
    end
  end
end

ActionController::Base.send(:include, VersionCake::ControllerAdditions)

if defined?(ActionController::API)
  ActionController::API.send(:include, VersionCake::ControllerAdditions)
end
