require './test/test_helper'

class QueryParameterStrategyTest < ActiveSupport::TestCase
  setup do
    @strategy = VersionCake::QueryParameterStrategy.new
  end

  test "a request with an api_version parameter retrieves the version" do
    request = stub(:query_parameters => {:api_version => '11', :other => 'parameter'})
    assert_equal 11, @strategy.extract(request)
  end

  test "a request with an Integer api_version parameter retrieves the version" do
    request = stub(:query_parameters => {:api_version => 11, :other => 'parameter'})
    assert_equal 11, @strategy.extract(request)
  end

  test "a request without an api_version parameter returns nil" do
    request = stub(:query_parameters => {:other => 'parameter', :another => 'parameter'})
    assert_nil @strategy.extract(request)
  end
end
