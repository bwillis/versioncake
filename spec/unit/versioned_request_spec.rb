require 'spec_helper'

describe VersionCake::VersionedRequest do
  context '#execute' do
    let(:request) { double 'Request' }
    let(:strategies) { [ instance_double('ExtractionStrategy', extract: request_version) ] }

    subject(:versioned_request) do
      request = VersionCake::VersionedRequest.new request, strategies
      request.execute
      request
    end

    context 'with a supported version' do
      let(:request_version) { 2 }

      it { expect(versioned_request.version).to eq 2 }
      it { expect(versioned_request.failed).to be_falsey }
    end

    context 'without a version' do
      let(:request_version) { nil }

      it { expect(versioned_request.version).to be_nil }
      it { expect(versioned_request.failed).to be_falsey }
    end

    context 'with a strategy failure' do
      let(:strategies) { [ lambda { raise 'Failed extraction' } ] }

      it { expect(versioned_request.version).to be_nil }
      it { expect(versioned_request.failed).to be_truthy }
    end
  end
end
