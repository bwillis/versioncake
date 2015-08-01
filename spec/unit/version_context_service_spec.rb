require 'spec_helper'

describe VersionCake::VersionContextService do

  let(:resource_user) do
    double('user_resource',
      uri: %r{user},
      supported_versions: [5,6,7],
      deprecated_versions: [3,4],
      obsolete_versions: [1,2]
    )
  end
  let(:resource_all) do
    double('default',
         uri: %r{.*},
         supported_versions: [6,7],
         deprecated_versions: [3,4,5],
         obsolete_versions: [1,2]
     )
  end
  let(:config) do
    double('config',
      versioned_resources: [resource_user, resource_all],
      missing_version: 9,
      extraction_strategies: [
        VersionCake::CustomStrategy.new(lambda{ |req| req.version })
      ]
    )
  end
  let(:service) { described_class.new(config) }

  describe '#create_context_from_request' do
    let(:request) { double(version: 5, path: 'users/123') }
    subject(:context) { service.create_context_from_request(request) }

    it { expect(context.version).to eq 5 }
    it { expect(context.resource).to eq resource_user }
    it { expect(context.result).to eq :supported }

    context 'for a deprecated version' do
      let(:request) { double(version: 5, path: 'posts/123') }

      it { expect(context.version).to eq 5 }
      it { expect(context.resource).to eq resource_all }
      it { expect(context.result).to eq :deprecated }
    end

    context 'for an obsolete version' do
      let(:request) { double(version: 2, path: 'users/123') }

      it { expect(context.version).to eq 2 }
      it { expect(context.resource).to eq resource_user }
      it { expect(context.result).to eq :obsolete }
    end
  end

  describe '#create_context' do
    let(:uri) { 'users/21' }
    let(:version) { 5 }
    subject(:context) { service.create_context(uri, version) }

    it { expect(context.version).to eq 5 }
    it { expect(context.resource).to eq resource_user }
    it { expect(context.result).to eq :supported }

    context 'for a deprecated version' do
      let(:uri) { 'posts/21' }
      let(:version) { 5 }

      it { expect(context.version).to eq 5 }
      it { expect(context.resource).to eq resource_all }
      it { expect(context.result).to eq :deprecated }
    end

    context 'for an obsolete version' do
      let(:uri) { 'posts/21' }
      let(:version) { 2 }

      it { expect(context.version).to eq 2 }
      it { expect(context.resource).to eq resource_all }
      it { expect(context.result).to eq :obsolete }
    end
  end
end
