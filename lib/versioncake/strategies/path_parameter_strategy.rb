module VersionCake
  class PathParameterStrategy < ExtractionStrategy

    def execute(request)
      version = nil
      request.path.split('/').find do |part|
        next unless match = part.match(%r{\Av(?<version>\d+)\z})
        version = match[:version]
        break
      end
      version
    end

  end
end
