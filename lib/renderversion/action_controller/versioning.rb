require 'action_controller'

module ActionController #:nodoc:
  module Versioning
    extend ActiveSupport::Concern

    included do
      prepend_before_filter :set_version
    end

    protected
      def set_version
        if request.headers.has_key?("version")
          requested_version = request.headers["version"].to_i
          @_lookup_context.versions = ActionView::Template::Versions.supported_versions(requested_version)
        end
      end
  end
end
ActionController::Base.send(:include, ActionController::Versioning)