module VersionCake
  class HttpAcceptParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.headers.key?("HTTP_ACCEPT") &&
          match = request.headers["HTTP_ACCEPT"].match(/#{@@version_string}=([0-9]+)/)
        match[1]
      end
    end

  end
end
