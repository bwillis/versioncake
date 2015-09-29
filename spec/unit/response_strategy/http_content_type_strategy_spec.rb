require 'spec_helper'

describe VersionCake::ResponseStrategy::HttpContentTypeStrategy do
  describe '#execute' do
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:context) { double('content', version: 4) }
    before do
      VersionCake::ResponseStrategy::HttpContentTypeStrategy.new.execute(
          context, nil, headers, nil
      )
    end

    it { expect(headers['Content-Type']).to eq 'application/json; api_version=4' }

    context 'for a header that ends in a semi colon' do
      let(:headers) { { 'Content-Type' => 'application/vnd.api+json; charset=utf-8;' } }

      it { expect(headers['Content-Type']).to eq 'application/vnd.api+json; charset=utf-8; api_version=4' }
    end

    context 'when there is no content type' do
      let(:headers) { {} }

      it { expect(headers.empty?).to eq true }
    end
  end
end