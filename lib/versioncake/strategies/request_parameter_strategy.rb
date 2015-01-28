module VersionCake
  class RequestParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.POST.has_key? version_key
        request.POST[version_key]
      end
    end

  end
end
