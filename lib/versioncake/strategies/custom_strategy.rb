module VersionCake
  class CustomStrategy < ExtractionStrategy
    def initialize(callback)
      @callback = callback
    end

    def execute(request)
      @callback.call(request)
    end
  end
end
