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

  test "set_version can be called to override the requested version" do
    get :index, "api_version" => "1", "override_version" => 2
    assert_equal 2, @controller.derived_version
  end

  test "responds with 404 when the version is larger than the supported version" do
    assert_raise VersionCake::UnsupportedVersionError do
      get :index, "api_version" => "4"
    end
  end

  test "responds with 404 when the version is lower than the latest version, but not an available version" do
    assert_raise VersionCake::UnsupportedVersionError do
      get :index, "api_version" => "0"
    end
  end

  test "render the default version version of the partial" do
    VersionCake::Configuration.any_instance.stubs(:default_version => 1)
    get :index, "api_version" => "abc"
    assert_equal "template v1", @response.body
  end
end
