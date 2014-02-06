module VersionCake
  class RequestParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.request_parameters.has_key? version_key.to_sym
        request.request_parameters[version_key.to_sym]
      end
    end

  end
end
