require 'spec_helper'

describe VersionCake::ResponseStrategy::HttpHeaderStrategy do
  describe '#execute' do
    let(:headers) { { } }
    let(:context) { double('content', version: 8) }
    before do
      VersionCake::ResponseStrategy::HttpHeaderStrategy.new.execute(
          context, nil, headers, nil
      )
    end

    it do
      expect(headers.keys).to include 'api-version'
      expect(headers['api-version']).to eq '8'
    end
  end
end