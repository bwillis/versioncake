class RendersController < ActionController::Base
  def index
    puts "RendersController#index"
    render "index"
  end
end