module VersionCake
  class HttpHeaderStrategy < ExtractionStrategy

    def execute(request)
      if request.headers.key? "HTTP_X_#{@@version_string.upcase}"
        request.headers["HTTP_X_#{@@version_string.upcase}"]
      end
    end

  end
end
