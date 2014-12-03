require 'spec_helper'

describe VersionCake::VersionedRequest do
  context 'a request' do
    before do
      allow_any_instance_of(described_class).to \
        receive(:apply_strategies).and_return(request_version)
    end
    subject(:versioned_request) { VersionCake::VersionedRequest.new double }

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
      before do
        allow_any_instance_of(VersionCake::Configuration).to \
          receive(:supports_version?).and_return(false)
      end
      let(:request_version) { 2 }

      it{ expect(versioned_request.is_latest_version?).to be_falsey }
    end

    context 'when the version is overriden by a parameter' do
      subject(:versioned_request) { VersionCake::VersionedRequest.new(double, 8) }
      let(:request_version) { 2 }

      it { expect(versioned_request.version).to eq 8 }
    end
  end
end
