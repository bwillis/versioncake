require './test/test_helper'

class VersionedRequestTest < ActiveSupport::TestCase
  test "a request with a supported version returns the version" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => 2)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert_equal 2, versioned_request.version
  end

  test "a request without a version returns the latest version" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => nil)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert_equal 3, versioned_request.version
  end

  test "has a method that returns true when a requested version is newer than any supported version" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => 99)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert versioned_request.is_newer_version
  end

  test "has a method that returns false when a requested version isn't newer than any supported version" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => 2)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert !versioned_request.is_newer_version
  end

  test "has a method that returns true when a requested version is deprecated" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => 2)
    VersionCake::Configuration.any_instance.stubs(:supports_version? => false)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert versioned_request.is_older_version
  end

  test "has a method that returns false when a requested version isn't deprecated" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => 2)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert !versioned_request.is_older_version
  end

  test "has a method to determine if requesting the latest version" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => nil)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert versioned_request.is_latest_version
  end

  test "has a method to retrieve the extracted version" do
    VersionCake::VersionedRequest.any_instance.stubs(:apply_strategies => nil)
    versioned_request = VersionCake::VersionedRequest.new(stub())
    assert_nil versioned_request.extracted_version
    assert_equal 3, versioned_request.version
  end

  test "the version can be overriden by a parameter" do
    versioned_request = VersionCake::VersionedRequest.new(stub(), 8)
    assert_equal 8, versioned_request.version
  end
end
