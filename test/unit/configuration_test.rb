require './test/test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  setup do
    @previous_versions = VersionCake::Configuration.supported_version_numbers
  end

  teardown do
    VersionCake::Configuration.supported_version_numbers = @previous_versions
  end

  test "supported_version_numbers can be set with range" do
    VersionCake::Configuration.supported_version_numbers = (1..7)
    assert_equal [7,6,5,4,3,2,1], VersionCake::Configuration.supported_version_numbers
  end

  test "supported_version_numbers can be set with an unordered array" do
    VersionCake::Configuration.supported_version_numbers = [2,4,1,5,3,6,7]
    assert_equal [7,6,5,4,3,2,1], VersionCake::Configuration.supported_version_numbers
  end

  test "supported_version_numbers can be set with a single value" do
    VersionCake::Configuration.supported_version_numbers = 19
    assert_equal [19], VersionCake::Configuration.supported_version_numbers
  end

  test "supports_version? is only true for given supported versions" do
    VersionCake::Configuration.supported_version_numbers = (1..7)
    VersionCake::Configuration.supported_version_numbers.each do |supported_version|
      assert VersionCake::Configuration.supports_version? supported_version
    end
  end

  test "supports_version? is not true for other versions" do
    VersionCake::Configuration.supported_version_numbers = (1..7)
    [-2,-1,0,8,9,10].each do |unsupported_version|
      assert !VersionCake::Configuration.supports_version?(unsupported_version)
    end
  end

  test "latest_version retrieves the highest supported version" do
    VersionCake::Configuration.supported_version_numbers = [4,1,3,9,2,54]
    assert_equal 54, VersionCake::Configuration.latest_version
  end

  test "default supported_version_numbers should be a logic set of version numbers" do
    assert_equal VersionCake::Configuration::SUPPORTED_VERSIONS_DEFAULT, (1..10)
  end
end
