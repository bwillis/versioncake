module VersionCake
  module ResponseStrategy
    class Base
      def execute(_context, _status, _headers, _response)
        raise Exception, "ResponseStrategy requires execute to be implemented"
      end

      def version_key
        VersionCake.config.version_key
      end

      def self.lookup(strategy)
        case strategy
          when String, Symbol
            strategy_name = "#{strategy}_strategy".camelize
            begin
              VersionCake::ResponseStrategy.const_get(strategy_name).new
            rescue
              raise Exception, "Unknown VersionCake response strategy #{strategy_name}"
            end
          else
            raise Exception, "Invalid response strategy"
        end
      end
    end
  end
end
