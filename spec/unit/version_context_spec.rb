require 'spec_helper'

describe VersionCake::VersionContext do
  let(:resource) do
    double(
        latest_version: 8,
        supported_versions: [5,6,7,8],
        deprecated_versions: [4],
        available_versions: [4,5,6,7,8],
        obsolete_versions: [2,3]
    )
  end
  let(:result) { :supported }
  subject(:context) { described_class.new(version, resource, result) }

  describe '#available_versions' do
    let(:version) { 7 }

    it { expect(context.available_versions).to eq [7,6,5,4] }

    context 'for a deprecated version' do
      let(:version) { 4 }
      let(:result) { :deprecated }

      it { expect(context.available_versions).to eq [4] }
    end

    context 'for an obsolete version' do
      let(:version) { 2 }
      let(:result) { :obsolete }

      it { expect(context.available_versions).to eq [] }
    end
  end

  describe '#is_latest_version?' do
    let(:version) { 8 }

    it { expect(context.is_latest_version?).to be true }

    context 'when it is less than the latest' do
      let(:version) { 7 }

      it { expect(context.is_latest_version?).to be false }
    end
  end
end
