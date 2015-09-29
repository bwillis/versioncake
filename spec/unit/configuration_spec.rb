require 'spec_helper'

describe VersionCake::Configuration do
  let(:supported_versions) { }
  subject(:config) do
    config = described_class.new
    if supported_versions
      config.supported_version_numbers = supported_versions
    end
    config
  end

  context '#supported_version_numbers' do
    context 'by default' do
      let(:supported_versions) { nil }

      it 'is a logical set of version numbers' do
        expect(config.supported_version_numbers).to eq (1..10).to_a.reverse
      end
    end

    context 'when set with a range' do
      let(:supported_versions) { (1..7) }

      it { expect(config.supported_version_numbers).to eq [7,6,5,4,3,2,1] }
    end

    context 'when set with an unordered array' do
      let(:supported_versions) { [2,4,1,5,3,6,7] }

      it { expect(config.supported_version_numbers).to eq [7,6,5,4,3,2,1] }
    end

    context 'when set with a single value' do
      let(:supported_versions) { 19 }

      it { expect(config.supported_version_numbers).to eq [19] }
    end
  end

  context '#supports_version?' do
    let(:supported_versions) { (1..7) }

    it 'is true for all supported versions' do
      config.supported_version_numbers.each do |supported_version|
        expect(config.supports_version?(supported_version)).to be_truthy
      end
    end

    it 'is false for other versions' do
      [-2,-1,0,8,9,10].each do |unsupported_version|
        expect(config.supports_version?(unsupported_version)).to be_falsey
      end
    end
  end

  context '#latest_version' do
    let(:supported_versions) { [4,1,3,9,2,54] }

    it { expect(config.latest_version).to eq 54 }
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
