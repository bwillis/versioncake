require "rails-api"

module Api
  class RendersController < ActionController::API
    def index
      render :json => requested_version
    end
  end
end