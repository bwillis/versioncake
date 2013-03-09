require 'active_support/core_ext/module/attribute_accessors.rb'

module ActionView
  class Template
    module Versions

      mattr_accessor :version_string
      self.version_string = "api_version"

      mattr_accessor :supported_version_numbers
      self.supported_version_numbers = []

      mattr_accessor :extraction_strategy
      self.extraction_strategy = [:query_parameter]

      def self.extract_version(request)
        version = nil
        extraction_strategy.each do |strategy|
          version = apply_strategy(request, strategy)
          break unless version.nil?
        end
        version
      end

      def self.apply_strategy(request, strategy)
        case strategy
          when Proc
            strategy.call(request)
          when :http_accept_parameter
            if request.headers.has_key?("HTTP_ACCEPT") &&
                match = request.headers["HTTP_ACCEPT"].match(%{#{@@version_string}=([0-9])})
              match[1].to_i
            end
          when :http_header
            if request.headers.has_key? "HTTP_X_#{@@version_string.upcase}"
              request.headers["HTTP_X_#{@@version_string.upcase}"].to_i
            end
          when :query_parameter
            if request.query_parameters.has_key? @@version_string.to_sym
              request.query_parameters[@@version_string.to_sym].to_i
            end
          when :request_parameter
            if request.request_parameters.has_key? @@version_string.to_sym
              request.request_parameters[@@version_string.to_sym].to_i
            end
          else
            raise "Unknown extraction strategy #{strategy}"
        end
      end

      def self.extraction_strategy=(val)
        case val
          when Array
            @@extraction_strategy = val
          else
            @@extraction_strategy = Array.wrap(val)
        end
      end

      def self.supported_version_numbers=(val)
        case val
          when Range
            @@supported_version_numbers = val.to_a
          when Array
            @@supported_version_numbers = val
          else
            @@supported_version_numbers = Array.wrap(val)
        end
        @@supported_version_numbers.sort!.reverse!
      end

      def self.supported_versions(requested_version_number=nil)
        supported_version_numbers.collect do |supported_version_number|
          if requested_version_number.nil? || supported_version_number <= requested_version_number
            :"v#{supported_version_number}"
          end
        end
      end

      def self.supports_version?(version)
        supported_version_numbers.include? version
      end

      def self.latest_version
        supported_version_numbers.first
      end

    end
  end
end