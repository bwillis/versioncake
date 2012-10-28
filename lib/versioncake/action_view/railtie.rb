require 'rails'

class ActionViewVersions < Rails::Railtie
  initializer "view_versions" do |app|
    ActiveSupport.on_load(:action_view) do
      if app.config.respond_to?(:view_versions)
        ActionView::Template::Versions.supported_version_numbers = app.config.view_versions
      end

      if app.config.respond_to?(:view_version_extraction_strategy)
        ActionView::Template::Versions.extraction_strategy = app.config.view_version_extraction_strategy
      end

      if app.config.respond_to?(:view_version_string)
        ActionView::Template::Versions.version_string = app.config.view_version_string
      end
    end
  end
end