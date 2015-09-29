require 'spec_helper'

describe VersionCake::ResponseStrategy::Base do
  describe '.lookup' do
    let(:strategy) { :http_content_type }
    subject(:found_strategy) { VersionCake::ResponseStrategy::Base.lookup(strategy) }

    it { expect(found_strategy.class).to eq VersionCake::ResponseStrategy::HttpContentTypeStrategy }
  end

  describe '#execute' do
    subject(:execute) { VersionCake::ResponseStrategy::Base.new.execute(nil,nil,nil,nil) }

    it { expect { execute }.to raise_error Exception }
  end
end