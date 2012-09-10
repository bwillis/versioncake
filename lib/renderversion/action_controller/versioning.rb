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

        @requested_version = if params.has_key? "_api_version"
           params["_api_version"].to_i
        elsif request.headers.has_key?("HTTP_API_VERSION")
          request.headers["HTTP_API_VERSION"].to_i
        end

        unless @requested_version.nil?
          @_lookup_context.versions = ActionView::Template::Versions.supported_versions(@requested_version)
        end

      end
  end
end
ActionController::Base.send(:include, ActionController::Versioning)