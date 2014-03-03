require 'action_controller/metal/exceptions'

module VersionCake
  class UnsupportedVersionError < ::ActionController::RoutingError
  end
end