require 'action_controller'

module ActionController #:nodoc:
  module Versioning
    extend ActiveSupport::Concern

    attr_accessor :requested_version

    included do
      prepend_before_filter :set_version
    end

    protected
      def set_version
        requested_version = ActionView::Template::Versions.extract_version request
        if ActionView::Template::Versions.supports_version? requested_version
          @requested_version = requested_version
          @_lookup_context.versions = ActionView::Template::Versions.supported_versions(requested_version)
        else
          @requested_version = ActionView::Template::Versions.latest_version
        end
      end
  end
end
ActionController::Base.send(:include, ActionController::Versioning)