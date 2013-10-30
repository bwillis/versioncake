require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class MultipleStrategyTest < ActionController::TestCase
  tests RendersController

  test "renders version 1 of the partial based on the header Accept" do
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=1"})
    get :index
    assert_equal "template v1", @response.body
  end

  test "renders the query parameter when accept parameter isn't available" do
    get :index, "api_version" => "1"
    assert_equal "template v1", @response.body
  end

  test "renders the higher priority accept parameter version" do
    @controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=2"})
    get :index, "api_version" => "1"
    assert_equal "template v2", @response.body
  end
end
