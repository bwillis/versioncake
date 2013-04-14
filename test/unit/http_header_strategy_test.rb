require './test/test_helper'

class HttpHeaderStrategyTest < ActiveSupport::TestCase
  setup do
    @strategy = VersionCake::HttpHeaderStrategy.new
  end

  test "a request with an HTTP_X_API_VERSION retrieves the version" do
    request = stub(:headers => {'HTTP_X_API_VERSION' => '11'})
    assert_equal 11, @strategy.extract(request)
  end

  test "a request without an HTTP_X_API_VERSION returns nil" do
    request = stub(:headers => {'HTTP_ACCEPT' => 'text/x-dvi; q=.8; mxb=100000; mxt=5.0, text/x-c'})
    assert_nil @strategy.extract(request)
  end
end
