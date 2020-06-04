require 'rails/railtie'

class Railtie < ::Rails::Railtie
  initializer :versioncake do
    ActiveSupport.on_load :action_controller do
      include VersionCake::ControllerAdditions
    end
  end
end
