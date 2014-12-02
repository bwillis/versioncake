module VersionCake
  class HttpHeaderStrategy < ExtractionStrategy

    def execute(request)
      if request.headers.key? "HTTP_#{version_key.upcase}"
        request.headers["HTTP_#{version_key.upcase}"]
      end
    end

  end
end
