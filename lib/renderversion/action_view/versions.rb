module ActionView

  class Template
    module Versions

      @@versions = []
      @@current_version = nil

      def self.supported_versions=(versions)
        puts "supported_versions being set: #{versions}"
        @@versions = versions.collect { |x| "v#{x}" }
      end

      def self.supported_versions
        puts "supported_versions being called: #{@@versions}"
        @@versions
      end

      def self.current_version
        @@current_version
      end

      def self.current_version=(version)
        @@current_version = version
      end
    end
  end

end