require 'active_support/core_ext/string/inflections.rb'

module VersionCake
  class ExtractionStrategy

    def extract(request)
      version = execute(request)
      if version.is_a?(Fixnum)
        version
      elsif version.is_a?(String) && /[0-9]+/.match(version)
        version.to_i
      else
        nil
      end
    end

    def version_key
      VersionCake::Railtie.config.versioncake.version_key
    end

    def execute(request)
      raise Exception, "ExtractionStrategy requires execute to be implemented"
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