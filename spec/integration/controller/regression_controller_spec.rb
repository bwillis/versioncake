require 'spec_helper'
require 'rails_helper'
require 'yaml'

describe RendersController, type: :controller do
  test_cases = YAML.load(File.open('./spec/fixtures/test_cases.yml'))
  test_cases.each do |test_case|
    context 'for a test case' do
      render_views
      before do
        allow(@request).to receive(:headers).and_return(headers)
        controller.versioned_request = nil # clear out the versioned request so it's not cached
      end

      let(:request) { test_case['request'] || {} }
      let(:headers) { request['headers'] || {} }
      let(:params) { request['params'] || {} }
      let(:method) { (request['method'] || 'get').to_sym }
      let(:test_response) { test_case['response'] }

      it "test yml test cases" do
        begin
          send(method, :index, params)
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
