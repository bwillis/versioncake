module ActionView

  class Template
    module Versions

      @@versions = []

      def self.supported_versions=(versions)
        @@versions = versions.collect { |x| "v#{x}" }
      end

      def self.supported_versions
        @@versions
      end
    end
  end

end