require 'active_support/core_ext/module/attribute_accessors.rb'

module ActionView
  class Template
    module Versions

      mattr_accessor :supported_version_numbers
      self.supported_version_numbers = []

      def self.supported_versions(requested_version_number=nil)
        self.supported_version_numbers.collect do |supported_version_number|
          if requested_version_number.nil? || supported_version_number <= requested_version_number
            :"v#{supported_version_number}"
          end
        end
      end

    end
  end
end