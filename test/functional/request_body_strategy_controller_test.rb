require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class RequestBodyStrategyTest < ActionController::TestCase
  tests RendersController

  setup do
    VersionCake::Configuration.extraction_strategy = :request_parameter
  end

  test "requested version is in the body" do
    post :index, "api_version" => "2"
    assert_equal 2, @controller.requested_version
  end
end
