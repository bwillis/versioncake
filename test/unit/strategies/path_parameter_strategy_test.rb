require './test/test_helper'

class PathParameterStrategyTest < ActiveSupport::TestCase
  setup do
    @strategy = VersionCake::PathParameterStrategy.new
  end

  test "a request with an api_version path parameter retrieves the version" do
    request = stub(:path_parameters => {:api_version => '11', :other => 'parameter'})
    assert_equal 11, @strategy.extract(request)
  end

  test "a request without an api_version path parameter returns nil" do
    request = stub(:path_parameters => {:other => 'parameter', :another => 'parameter'})
    assert_nil @strategy.extract(request)
  end
end
