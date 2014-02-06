module VersionCake
  class PathParameterStrategy < ExtractionStrategy

    def execute(request)
      if request.path_parameters.key? version_key.to_sym
        request.path_parameters[version_key.to_sym]
      end
    end

  end
end
