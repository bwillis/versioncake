require 'spec_helper'
require 'rack'

describe VersionCake::Rack::Middleware do
  let(:response_strategy) { nil }
  let(:config) do
    VersionCake::Configuration.new.tap do |config|
      config.extraction_strategy = [:http_header]
      config.response_strategy = response_strategy
      config.resources do |resource_config|
        resource_config.resource %r{.*}, [], [], (1..5)
      end
    end
  end
  let(:upstream_headers) { {} }
  let(:middleware) do
    VersionCake::Rack::Middleware.new(
      double(call: [nil, upstream_headers, nil] ),
      config
    )
  end

  context '#call' do
    let(:env) do
      {
        'SCRIPT_NAME' => '',
        'PATH_INFO' => '',
        'HTTP_API_VERSION' => '1'
      }
    end

    subject { middleware.call(env) }
    let(:response_headers) { subject[1] }

    context 'when response_strategy is http_header' do
      let(:response_strategy) { [:http_header] }

      it 'sets the version in the response header' do
        expect(response_headers['api-version']).to eq '1'
      end
    end

    context 'when response_strategy is http_content_type' do
      let(:response_strategy) { [:http_content_type] }
      let(:upstream_headers) { { 'Content-Type' => 'application/vnd.api+json; charset=utf-8;' } }

      it 'sets the version in the content type' do
        expect(response_headers['Content-Type']).to match 'application/vnd.api+json; charset=utf-8; api_version=1'
      end

      context 'with a simpler content type' do
        let(:upstream_headers) { { 'Content-Type' => 'application/json' } }

        it 'sets the version in the content type' do
          expect(response_headers['Content-Type']).to match 'application/json; api_version=1'
        end
      end
    end
  end
end
