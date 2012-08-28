require 'active_support/core_ext/module/attribute_accessors'
require 'rack'
require 'action_dispatch/http/url'
require 'action_dispatch/http/upload'
require 'action_dispatch/http/filter_parameters'
require 'action_dispatch/http/parameters'
require 'action_dispatch/http/cache'
require 'action_dispatch/http/mime_negotiation'
require 'action_dispatch/http/request'

module ActionController #:nodoc:
  module Versioning
    extend ActiveSupport::Concern

    included do
      prepend_before_filter :set_version
    end

    protected
      def set_version
        if request.headers.has_key?(:version)
          ActionView::Templates::Versions.set_version "v#{request.headers(:version)}".to_sym
        end
      end
  end
end
