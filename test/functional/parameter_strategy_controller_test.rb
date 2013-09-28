require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class ParameterStrategyTest < ActionController::TestCase
  tests RendersController

  setup do
    VersionCake::Configuration.extraction_strategy = :query_parameter
  end

  test "render version 1 of the partial based on the parameter _api_version" do
    get :index, "api_version" => "1"
    assert_equal @response.body, "template v1"
  end

  test "render version 2 of the partial based on the parameter _api_version" do
    get :index, "api_version" => "2"
    assert_equal @response.body, "template v2"
  end

  test "render the latest available version (v2) of the partial based on the parameter _api_version" do
    get :index, "api_version" => "3"
    assert_equal @response.body, "template v2"
  end
end
