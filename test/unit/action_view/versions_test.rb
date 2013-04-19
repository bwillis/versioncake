require './test/test_helper'

class VersionsTest < ActiveSupport::TestCase
  setup do
    @previous_versions = ActionView::Template::Versions.supported_version_numbers
  end

  teardown do
    ActionView::Template::Versions.supported_version_numbers = @previous_versions
  end

  test "supported_version_numbers can be set with range" do
    ActionView::Template::Versions.supported_version_numbers = (1..7)
    assert_equal [7,6,5,4,3,2,1], ActionView::Template::Versions.supported_version_numbers
  end

  test "supported_version_numbers can be set with an unordered array" do
    ActionView::Template::Versions.supported_version_numbers = [2,4,1,5,3,6,7]
    assert_equal [7,6,5,4,3,2,1], ActionView::Template::Versions.supported_version_numbers
  end

  test "supported_version_numbers can be set with a single value" do
    ActionView::Template::Versions.supported_version_numbers = 19
    assert_equal [19], ActionView::Template::Versions.supported_version_numbers
  end

  test "supports_version? is only true for given supported versions" do
    ActionView::Template::Versions.supported_version_numbers = (1..7)
    ActionView::Template::Versions.supported_version_numbers.each do |supported_version|
      assert_true ActionView::Template::Versions.supports_version? supported_version
    end
  end

  test "supports_version? is not true for other versions" do
    ActionView::Template::Versions.supported_version_numbers = (1..7)
    [-2,-1,0,8,9,10].each do |unsupported_version|
      assert_false ActionView::Template::Versions.supports_version? unsupported_version
    end
  end

  test "latest_version retrieves the highest supported version" do
    ActionView::Template::Versions.supported_version_numbers = [4,1,3,9,2,54]
    assert_equal 54, ActionView::Template::Versions.latest_version
  end
end
