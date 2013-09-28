require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class AcceptHeaderStrategyTest < ActionController::TestCase
  tests RendersController

  setup do
    VersionCake::Configuration.extraction_strategy = :http_accept_parameter
  end

  test "render version 1 of the partial based on the header Accept" do
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=1"})
    get :index
    assert_equal @response.body, "template v1"
  end

  test "render version 2 of the partial based on the header Accept" do
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=2"})
    get :index
    assert_equal @response.body, "template v2"
  end

  test "render the latest available version (v2) of the partial based on the header Accept" do
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=3"})
    get :index
    assert_equal @response.body, "template v2"
  end

  test "render the latest version of the partial" do
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=abc"})
    get :index
    assert_equal @response.body, "template v2"
  end

  test "render the default version version of the partial" do
    VersionCake::Configuration.default_version = 1
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=abc"})
    get :index
    assert_equal @response.body, "template v1"
    VersionCake::Configuration.default_version = nil
  end

end
