require 'action_view'

ActionView::Railtie.class_eval do

  initializer "action_view.view_versions" do |app|
    ActiveSupport.on_load(:action_view) do
      unless app.config.action_view.view_versions.nil?
        ActionView::Templates::Versions.set_versions app.config.action_view.view_versions
      end
    end
  end

end