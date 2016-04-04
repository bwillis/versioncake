require 'spec_helper'

describe VersionCake::VersionedResource do

  let(:resource) { described_class.new('hello/123', [1,2], [3], [4,5,6])}

  describe '#available_versions' do
    subject { resource.available_versions }

    it { is_expected.to match_array (3..6).to_a }

    context 'when given out of order' do
      let(:resource) { described_class.new('hello/123', [1,2], [3], [7,6,4,5])}

      it 'order them' do
        is_expected.to match_array (3..7).to_a
      end
    end
  end

  describe '#latest_version' do
    subject { resource.latest_version }

    it { is_expected.to eq 6 }
  end
end
