require 'spec_helper'

describe VersionCake::VersionChecker do
  let(:resource) do
    double(
      supported_versions: [5,6],
      deprecated_versions: [4],
      obsolete_versions: [2,3],
    )
  end
  let(:version) { }
  subject do
    checker = VersionCake::VersionChecker.new(resource, version)
    checker.execute
  end

  describe '#execute' do
    context 'when no version is passed in' do
      let(:version) { nil }

      it { is_expected.to eq :no_version }
    end

    context 'when the version is a supported version' do
      let(:version) { 5 }

      it { is_expected.to eq :supported }
    end

    context 'when the version is an obsolete version' do
      let(:version) { 3 }

      it { is_expected.to eq :obsolete }
    end

    context 'when the version is a deprecated version' do
      let(:version) { 4 }

      it { is_expected.to eq :deprecated }
    end

    context 'when the version is greater than the supported versions' do
      let(:version) { 7 }

      it { is_expected.to eq :version_too_high }
    end

    context 'when the version is less than the supported versions' do
      let(:version) { 1 }

      it { is_expected.to eq :version_too_low }
    end

    context 'when the version is of a strange format' do
      let(:version) { '1' }

      it { is_expected.to eq :invalid_format }
    end
  end
end
