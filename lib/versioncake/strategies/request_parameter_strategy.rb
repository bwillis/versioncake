module VersionCake
  class RequestParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.request_parameters.has_key? @@version_string.to_sym
        request.request_parameters[@@version_string.to_sym].to_i
      end
    end

  end
end
