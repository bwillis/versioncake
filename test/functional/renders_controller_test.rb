require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class RendersControllerTest < ActionController::TestCase

  test "render latest version of partial" do
    get :index
    assert_equal "template v2", @response.body
  end

  test "exposes the requested version" do
    get :index, "api_version" => "1"
    assert_equal 1, @controller.requested_version
  end

  test "exposes latest version when requesting the latest" do
    get :index, "api_version" => "3"
    assert @controller.is_latest_version
  end

  test "reports not the latest version" do
    get :index, "api_version" => "1"
    assert !@controller.is_latest_version
  end

  test "exposes the derived version when the version is not set and no default" do
    get :index
    assert_equal 3, @controller.derived_version
  end

  test "exposes the default version when the version is not set default is set" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index
    assert_equal 1, @controller.derived_version
  end

  test "requested version is blank when the version is not set" do
    get :index
    assert @controller.requested_version.blank?
  end

  test "is_newer_version is true if the requested version is larger than the supported versions" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "4" rescue ActionController::RoutingError
    assert @controller.is_newer_version
  end

  test "is_newer_version is false if the requested version is a supported version" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "1"
    assert !@controller.is_newer_version
  end

  test "is_newer_version is false if the requested version is a deprecated version" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "0" rescue ActionController::RoutingError
    assert !@controller.is_newer_version
  end

  test "is_older_version is true if the requested version is a deprecated version" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "0" rescue ActionController::RoutingError
    assert @controller.is_older_version
  end

  test "is_older_version is false if the requested version is a supported version" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "1"
    assert !@controller.is_older_version
  end

  test "is_older_version is false if the requested version is larger than the supported versions" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "4" rescue ActionController::RoutingError
    assert !@controller.is_older_version
  end

  test "a request for a deprecated version raises an exception" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    assert_raise ActionController::RoutingError do
      get :index, "api_version" => "0"
    end
  end

  test "a request for a version that is higher than the latest version raises an exception" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    assert_raise ActionController::RoutingError do
      get :index, "api_version" => "4"
    end
  end

  test "set_version can be called to override the requested version" do
    get :index, "api_version" => "1", "override_version" => 2
    assert_equal 2, @controller.derived_version
  end

  test "responds with 404 when the version is larger than the supported version" do
    assert_raise ActionController::RoutingError do
      get :index, "api_version" => "4"
    end
  end

  test "responds with 404 when the version is lower than the latest version, but not an available version" do
    assert_raise ActionController::RoutingError do
      get :index, "api_version" => "0"
    end
  end

  test "render the default version version of the partial" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "abc"
    assert_equal "template v1", @response.body
  end
end
