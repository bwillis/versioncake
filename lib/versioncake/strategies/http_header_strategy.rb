module VersionCake
  class HttpHeaderStrategy < ExtractionStrategy

    def execute(request)
      if request.env.key? "HTTP_#{version_key.upcase}"
        request.env["HTTP_#{version_key.upcase}"]
      end
    end

  end
end
