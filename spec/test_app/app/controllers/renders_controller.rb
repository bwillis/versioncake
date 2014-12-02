require "action_controller"
require "action_controller/base"

class RendersController < ActionController::Base
  def index
    if params[:override_version]
      set_version(params[:override_version].to_i)
    end
  end
end
