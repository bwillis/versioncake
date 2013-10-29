module VersionCake
  class QueryParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.params.key? @@version_string.to_sym
        request.params[@@version_string.to_sym]
      end
    end

  end
end
