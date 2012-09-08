require 'rails'

class ActionViewVersions < Rails::Railtie
  initializer "view_versions" do |app|
    ActiveSupport.on_load(:action_view) do
      if app.config.view_versions.nil?
        ActionView::Template::Versions.supported_version_numbers = []
      else
        ActionView::Template::Versions.supported_version_numbers = app.config.view_versions
      end
    end
  end
end