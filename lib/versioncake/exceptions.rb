require 'action_controller/metal/exceptions'

module VersionCake
  class UnsupportedVersionError < ::ActionController::RoutingError
  end
  class ObsoleteVersionError < ::ActionController::RoutingError
  end
  class MissingVersionError <  ::ActionController::RoutingError
  end
end