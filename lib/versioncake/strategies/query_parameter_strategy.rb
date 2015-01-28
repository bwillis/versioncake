module VersionCake
  class QueryParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.GET.key? version_key
        request.GET[version_key].to_s
      end
    end

  end
end
