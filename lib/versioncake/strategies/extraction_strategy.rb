require 'active_support/core_ext/string/inflections.rb'

module VersionCake
  class ExtractionStrategy

    def extract(request)
      version = execute(request)
      if version.is_a?(Integer)
        version
      elsif version.is_a?(String) && /[0-9]+/.match(version)
        version.to_i
      elsif version_blank?(version)
        nil
      else
        raise Exception, "Invalid format for version number."
      end
    end

    def version_key
      VersionCake.config.version_key
    end

    def version_blank?(version)
      version.nil? || (version.is_a?(String) && version.length == 0)
    end

    # Execute should return a number or a numeric string if it successfully finds a version. 
    # If no version is found, nil should be returned. Any other results returned will raise
    # an exception.
    def execute(request)
      raise Exception, "ExtractionStrategy requires execute to be implemented"
    end

    def self.list(*strategies)
      strategies.map do |strategy|
        lookup(strategy)
      end
    end

    def self.lookup(strategy)
      case strategy
        when String, Symbol
          strategy_name = "#{strategy}_strategy".camelize
          begin
            VersionCake.const_get(strategy_name).new
          rescue
            raise Exception, "Unknown VersionCake extraction strategy #{strategy_name}"
          end
        when Proc
          if strategy.arity == 1
            VersionCake::CustomStrategy.new(strategy)
          else
            raise Exception, "Custom proc extraction strategy requires a single parameter"
          end
        when Object
          if !strategy.methods.include?(:execute)
            raise Exception, "Custom extraction strategy requires an execute method"
          elsif strategy.method(:execute).arity != 1
            raise Exception, "Custom extraction strategy requires an execute method with a single parameter"
          else
            VersionCake::CustomStrategy.new(strategy)
          end
        else
          raise Exception, "Invalid extration strategy"
      end
    end
  end
end
