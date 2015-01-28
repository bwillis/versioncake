module VersionCake
  class PathParameterStrategy < ExtractionStrategy

    def execute(request)
      version = nil
      request.path.split('/').find do |part|
        next unless match = part.match(%r{v(?<version>\d+)})
        version = match[:version]
        break
      end
      version
    end

  end
end
