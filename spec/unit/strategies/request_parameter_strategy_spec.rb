require 'spec_helper'

describe VersionCake::RequestParameterStrategy do
  let(:strategy) { VersionCake::RequestParameterStrategy.new }
  subject { strategy.extract(request) }

  context "a request with an api_version request parameter retrieves the version" do
    let(:request) { instance_double('Request', POST: {'api_version' => '11', 'other' => 'parameter'}) }

    it { is_expected.to eq 11 }
  end

  context "a request without an api_version request parameter returns nil" do
    let(:request) { instance_double('Request', POST: \
      {'other' => 'parameter', 'another' => 'parameter'}) }

    it { is_expected.to be_nil }
  end
end
