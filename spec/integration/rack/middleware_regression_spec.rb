require './spec/rails_helper'
require 'yaml'

describe VersionCake::Rack::Middleware do
  let(:app) do
    rack = Rack::Builder.new do
      config = VersionCake::Configuration.new
      config.resources { |r| r.resource %r{.*}, [], [], (1..5) }
      use VersionCake::Rack::Middleware, config
      run lambda { |env| [ 200, {},[ env['versioncake.context'].version ] ] }
    end
    Rack::MockRequest.new(rack)
  end

  test_cases = YAML.load(File.open('./spec/fixtures/test_cases.yml'))
  test_cases.each do |test_case|
    context 'for a test case' do


      let(:data) { test_case['request'] || {} }
      let(:method) { (data['method'] || 'get').to_sym }
      let(:headers) { data['headers'] || {} }
      let(:params) { data['params'] || {} }
      let(:test_response) { test_case['response'] }

      it "test yml test cases" do
        begin
          _response_status, _response_headers, response = app.request(method, '/renders', headers.merge(params: params))
          expect(response.body).to(eq(test_response), custom_message(headers, params, method, response.body, test_response))
        rescue => e
          raise custom_message(headers, params, method, response.body, test_response) + ", but it failed with an exception '#{e.message}'"
        end
      end
    end
  end

  def custom_message(headers, params, method, actual_response, expected_response)
    data = []
    data << "headers:#{headers}" if headers
    data << "params:#{params}" if params
    "Expected #{data.join(',')} with method #{method} to yield '#{expected_response}', but got '#{actual_response}'"
  end
end
