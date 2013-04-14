require './test/test_helper'

class HttpAcceptParameterStrategyTest < ActiveSupport::TestCase
  setup do
    @strategy = VersionCake::HttpAcceptParameterStrategy.new
  end

  test "a request with an HTTP_ACCEPT version retrieves the version" do
    request = stub(:headers => {'HTTP_ACCEPT' => 'application/xml; api_version=11'})
    assert_equal 11, @strategy.extract(request)
  end

  test "a request without an HTTP_ACCEPT version returns nil" do
    request = stub(:headers => {'HTTP_ACCEPT' => 'text/x-dvi; q=.8; mxb=100000; mxt=5.0, text/x-c'})
    assert_nil @strategy.extract(request)
  end
end
