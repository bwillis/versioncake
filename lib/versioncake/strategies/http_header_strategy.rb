module VersionCake
  class HttpHeaderStrategy < ExtractionStrategy

    def execute(request)
      if request.headers.key? "HTTP_X_#{version_key.upcase}"
        request.headers["HTTP_X_#{version_key.upcase}"]
      end
    end

  end
end
