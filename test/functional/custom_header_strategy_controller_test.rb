require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class CustomHeaderStrategyTest < ActionController::TestCase
  tests RendersController

  setup do
    VersionCake::Configuration.extraction_strategy = :http_header
  end

  test "renders version 1 of the partial based on the header API-Version" do
    @controller.request.stubs(:headers).returns({"HTTP_X_API_VERSION" => "1"})
    get :index
    assert_equal "template v1", @response.body
  end

  test "renders version 2 of the partial based on the header API-Version" do
    @controller.request.stubs(:headers).returns({"HTTP_X_API_VERSION" => "2"})
    get :index
    assert_equal "template v2", @response.body
  end

  test "renders the latest available version (v2) of the partial based on the header API-Version" do
    @controller.request.stubs(:headers).returns({"HTTP_X_API_VERSION" => "3"})
    get :index
    assert_equal "template v2", @response.body
  end
end
