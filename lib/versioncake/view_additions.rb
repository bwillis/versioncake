require 'action_view'

if ActionPack::VERSION::MAJOR >= 7
  require_relative 'view_additions_rails7'
elsif ActionPack::VERSION::MAJOR >= 6
  require_relative 'view_additions_rails6'
elsif ActionPack::VERSION::MAJOR >= 5
  require_relative 'view_additions_rails5'
else
  raise StandardError.new('Unsupported Rails version')
end
