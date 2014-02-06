require 'rails'

module VersionCake
  class Railtie < ::Rails::Railtie
    config.versioncake = VersionCake::Configuration.new
  end
end