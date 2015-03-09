require 'spec_helper'

describe VersionCake::VersionedResource do

  let(:resource) { described_class.new('hello/123', [1,2], [3], [4,5,6])}

  describe '#latest_version' do
    subject { resource.latest_version }

    it { is_expected.to eq 6 }
  end
end
