require 'rails/generators'

module Versioncake
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../../templates', __FILE__)

    desc 'Creates a Version Cake initializer in your application.'
    def copy_initializer
      template 'versioncake.rb', 'config/initializers/versioncake.rb'
    end
  end
end
