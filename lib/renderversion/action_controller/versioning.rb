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
        if request.headers.has_key?("HTTP_API_VERSION")
          @requested_version = request.headers["HTTP_API_VERSION"].to_i
          @_lookup_context.versions = ActionView::Template::Versions.supported_versions(@requested_version)
        else
          @requested_version = nil
        end
      end
  end
end
ActionController::Base.send(:include, ActionController::Versioning)