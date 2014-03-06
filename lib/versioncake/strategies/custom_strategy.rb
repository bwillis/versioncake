module VersionCake
  class CustomStrategy < ExtractionStrategy
    def initialize(callback)
      @callback = callback
    end

    def execute(request)
      if @callback.respond_to? :execute
        @callback.execute(request)
      else
        @callback.call(request)
      end
    end
  end
end
