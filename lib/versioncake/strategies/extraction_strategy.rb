require 'active_support/core_ext/string/inflections.rb'

module VersionCake
  class ExtractionStrategy

    def extract(request)
      version = execute(request)
      return version.to_i if version && /[0-9]+/.match(version)
    end

    def version_key
      VersionCake::Railtie.config.versioncake.version_key
    end

    def execute(request)
      raise Exception, "ExtractionStrategy requires execute to be implemented"
    end

    def self.lookup(strategy)
      if strategy.class == Proc
        if strategy.arity == 1
          VersionCake::CustomStrategy.new(strategy)
        else
          raise Exception, "Custom extraction strategy requires a single parameter"
        end
      else
        strategy_name = "#{strategy}_strategy".camelize
        begin
          VersionCake.const_get(strategy_name).new
        rescue
          raise Exception, "Unknown VersionCake extraction strategy #{strategy_name}"
        end
      end

    end

  end
end
