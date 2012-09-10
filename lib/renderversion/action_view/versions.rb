require 'active_support/core_ext/module/attribute_accessors.rb'

module ActionView
  class Template
    module Versions

      mattr_accessor :supported_version_numbers
      self.supported_version_numbers = []

      def self.supported_version_numbers=(val)
        case val
          when Range
          @@supported_version_numbers = val.to_a
        when Array
          @@supported_version_numbers = val
        else
          @@supported_version_numbers = Array.wrap(val)
        end
        @@supported_version_numbers.reverse!
      end

      def self.supported_versions(requested_version_number=nil)
        self.supported_version_numbers.collect do |supported_version_number|
          if requested_version_number.nil? || supported_version_number <= requested_version_number
            :"v#{supported_version_number}"
          end
        end
      end

      def self.supports_version?(version)
        ActionView::Template::Versions.supported_version_numbers.include? version
      end

      def self.latest_version
        ActionView::Template::Versions.supported_version_numbers.first
      end

    end
  end
end