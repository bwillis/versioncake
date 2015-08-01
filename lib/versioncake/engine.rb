module VersionCake
  class Engine < Rails::Engine
    initializer 'version_cake.add_middleware' do |app|
      app.middleware.use VersionCake::Rack::Middleware
    end
  end
end