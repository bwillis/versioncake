require 'action_controller'

module ActionController #:nodoc:
  module Versioning
    extend ActiveSupport::Concern

    attr_accessor :requested_version, :is_latest_version, :derived_version

    included do
      prepend_before_filter :set_version
    end

    protected
      def set_version
        @requested_version = ActionView::Template::Versions.extract_version request

        if @requested_version.nil?
          @derived_version = ActionView::Template::Versions.latest_version
        elsif ActionView::Template::Versions.supports_version? @requested_version
          @derived_version = @requested_version
        elsif @requested_version > ActionView::Template::Versions.latest_version
          raise ActionController::RoutingError.new("No route match for version")
        else
          raise ActionController::RoutingError.new("Version is deprecated")
        end
        @_lookup_context.versions = ActionView::Template::Versions.supported_versions(@derived_version)
        @is_latest_version = @derived_version == ActionView::Template::Versions.latest_version
      end
  end
end
ActionController::Base.send(:include, ActionController::Versioning)