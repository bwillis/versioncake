module VersionCake
  class VersionedResponseService
    def initialize(config)
      @strategies = config.response_strategies
    end

    def inject_version(versioned_context, status, headers, response)
      @strategies.each do |strategy|
        strategy.execute(versioned_context, status, headers, response)
      end
    end
  end
end