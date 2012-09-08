require 'active_support/core_ext/module/attribute_accessors.rb'

module ActionView

  class Template
    module Versions

      mattr_accessor :supported_versions
      self.supported_versions = []

      def self.supported_versions_for(requested_version=0)
        self.supported_versions.select do |supported_version|
          if supported_version <= requested_version
            return :"v#{supported_version}"
          end
        end
      end
    end
  end

end