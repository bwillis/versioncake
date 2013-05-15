require 'rails'

class ActionViewVersions < Rails::Railtie
  initializer "view_versions" do |app|
    ActiveSupport.on_load(:action_view) do
      if app.config.respond_to?(:view_versions)
        VersionCake::Configuration.supported_version_numbers = app.config.view_versions
      end

      if app.config.respond_to?(:view_version_extraction_strategy)
        VersionCake::Configuration.extraction_strategy = app.config.view_version_extraction_strategy
      end

      if app.config.respond_to?(:view_version_string)
        VersionCake::ExtractionStrategy.version_string = app.config.view_version_string
      end

      if app.config.respond_to?(:default_version)
        VersionCake::Configuration.default_version = app.config.default_version
      end
    end
  end
end