require 'spec_helper'

describe VersionCake::VersionedResponseService do

  let(:config) { double(response_strategies: [VersionCake::ResponseStrategy::HttpHeaderStrategy.new]) }
  let(:service) { described_class.new(config)}

  describe '#inject_version' do
    let(:context) { double('content', version: 2) }
    let(:headers) { { } }

    before { service.inject_version(context, nil, headers, nil) }

    it { expect(headers['api-version']).to eq '2' }

    context 'when configured with multiple response strategies' do
      let(:headers) { { 'Content-Type' => 'application/vnd.api+json; charset=utf-8;' } }

      let(:config) do
        double(response_strategies: [
            VersionCake::ResponseStrategy::HttpHeaderStrategy.new,
            VersionCake::ResponseStrategy::HttpContentTypeStrategy.new
        ])
      end

      it { expect(headers['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8; api_version=2' }
      it { expect(headers['api-version']).to eq '2' }
    end
  end
end
