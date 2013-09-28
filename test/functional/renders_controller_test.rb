require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'

class RendersControllerTest < ActionController::TestCase

  setup do
    # change the version string for configuration testing
    VersionCake::ExtractionStrategy.version_string = "version"
  end

  teardown do
    VersionCake::ExtractionStrategy.version_string = "api_version"
  end

  test "render latest version of partial" do
    get :index
    assert_equal @response.body, "template v2"
  end

  test "exposes the requested version" do
    get :index, "version" => "1"
    assert_equal @controller.requested_version, 1
  end

  test "exposes latest version when requesting the latest" do
    get :index, "version" => "3"
    assert @controller.is_latest_version
  end

  test "reports not the latest version" do
    get :index, "version" => "1"
    assert !@controller.is_latest_version
  end

  test "exposes the derived version when the version is not set and no default" do
    get :index
    assert_equal 3, @controller.derived_version
  end

  test "exposes the default version when the version is not set default is set" do
    VersionCake::Configuration.default_version = 1
    get :index
    assert_equal 1, @controller.derived_version
    VersionCake::Configuration.default_version = nil
  end

  test "requested version is blank when the version is not set" do
    get :index
    assert @controller.requested_version.blank?
  end

  test "set_version can be called to override the requested version" do
    get :index, "version" => "1", "override_version" => 2
    assert_equal 2, @controller.derived_version
  end

  test "responds with 404 when the version is larger than the supported version" do
    assert_raise ActionController::RoutingError do
      get :index, "version" => "4"
    end
  end

  test "responds with 404 when the version is lower than the latest version, but not an available version" do
    previous_versions = VersionCake::Configuration.supported_version_numbers
    VersionCake::Configuration.supported_version_numbers = [2,3]
    assert_raise ActionController::RoutingError do
      get :index, "version" => "1"
    end
    VersionCake::Configuration.supported_version_numbers = previous_versions
  end
end
