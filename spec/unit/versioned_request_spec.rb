require 'spec_helper'

describe VersionCake::VersionedRequest do
  context 'a request' do
    let(:request) do
      request = double query_parameters: { }
      request.query_parameters[:api_version] = request_version if request_version
      request
    end
    let(:config) do
      config = VersionCake::Configuration.new
      config.supported_version_numbers = (2..3)
      config
    end
    subject(:versioned_request) { VersionCake::VersionedRequest.new request, config }

    context 'with a supported version' do
      let(:request_version) { 2 }

      it { expect(versioned_request.version).to eq 2 }
      it { expect(versioned_request.is_latest_version?).to be_falsey }
    end

    context 'without a version' do
      let(:request_version) { nil }

      it { expect(versioned_request.version).to eq 3 }
      it { expect(versioned_request.is_latest_version?).to be_truthy }
      it { expect(versioned_request.extracted_version).to be_nil }
    end

    context 'with a higher version than the latest' do
      let(:request_version) { 99 }

      it{ expect(versioned_request.is_latest_version?).to be_falsey }
    end

    context 'with a deprecated version' do
      let(:request_version) { 1 }

      it{ expect(versioned_request.is_latest_version?).to be_falsey }
    end

    context 'when the version is overridden by a parameter' do
      subject(:versioned_request) { VersionCake::VersionedRequest.new(request, config, 8) }
      let(:request_version) { 2 }

      it { expect(versioned_request.version).to eq 8 }
    end
  end
end
