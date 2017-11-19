require 'spec_helper'

describe VersionCake::Configuration do
  subject(:config) { described_class.new }

  context '#missing_version' do
    before { config.missing_version = 5 }

    it { expect(config.missing_version).to eq 5 }
    it { expect(config.default_version).to eq 5 }
    it { expect(config.missing_version_use_unversioned_template).to eq false }

    context 'when set to use the base template' do
      before { config.missing_version = :unversioned_template }

      it { expect(config.missing_version).to eq :unversioned_template }
      it { expect(config.default_version).to be_nil }
      it { expect(config.missing_version_use_unversioned_template).to eq true }
    end
  end

  context 'by default' do
    it 'has all extraction strategies' do
      expect(config.extraction_strategies.map(&:class)).to match_array(
        VersionCake::ExtractionStrategy.list(
          :http_accept_parameter, :http_header, :request_parameter, :path_parameter, :query_parameter
        ).map(&:class)
      )
    end
  end
end
