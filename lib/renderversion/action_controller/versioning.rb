require 'active_support/core_ext/module/attribute_accessors'
require 'rack'
require 'action_dispatch/http/url'
require 'action_dispatch/http/upload'
require 'action_dispatch/http/filter_parameters'
require 'action_dispatch/http/parameters'
require 'action_dispatch/http/cache'
require 'action_dispatch/http/mime_negotiation'
require 'action_dispatch/http/request'
require 'abstract_controller'
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