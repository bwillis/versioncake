require './test/test_helper'
require 'action_controller'
require 'action_controller/test_case'
require 'yaml'

class StrategyControllerTest < ActionController::TestCase
  tests RendersController

  setup do
    @test_cases = YAML.load(File.open(Rails.root.join('fixtures', 'test_cases.yml')))
  end

  test "test yml test cases" do
    @test_cases.each do |test_case|
      request = (test_case['request'] || {})
      headers  = request['headers']
      params   = request['params']
      method   = (request['method'] || "get").to_sym
      response = test_case['response']
      @controller.request.stubs(:headers).returns(headers || {})
      begin
        send(method, :index, params || {})
        assert_equal(response, @response.body, custom_message(headers, params, method, response))
      rescue => e
        fail(custom_message(headers, params, method, response) + ", but it failed with an exception '#{e.message}'")
      end
    end
  end

  def custom_message(headers, params, method, response)
    data = []
    data << "headers:#{headers}" if headers
    data << "params:#{params}" if params
    "Expected #{data.join(",")} with method #{method} to yield #{response}"
  end

end
