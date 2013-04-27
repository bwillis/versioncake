require './test/test_helper'

class RequestParameterStrategyTest < ActiveSupport::TestCase
  setup do
    @strategy = VersionCake::RequestParameterStrategy.new
  end

  test "a request with an api_version request parameter retrieves the version" do
    request = stub(:request_parameters => {:api_version => '11', :other => 'parameter'})
    assert_equal 11, @strategy.extract(request)
  end

  test "a request without an api_version request parameter returns nil" do
    request = stub(:request_parameters => {:other => 'parameter', :another => 'parameter'})
    assert_nil @strategy.extract(request)
  end
end
