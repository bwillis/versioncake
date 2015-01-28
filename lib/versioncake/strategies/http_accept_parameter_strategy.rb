module VersionCake
  class HttpAcceptParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.env.key?('HTTP_ACCEPT') &&
          match = request.env['HTTP_ACCEPT'].match(/#{version_key}=([0-9]+)/)
        match[1]
      end
    end

  end
end
