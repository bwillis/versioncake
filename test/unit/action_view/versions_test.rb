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
end
