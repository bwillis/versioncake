require 'spec_helper'

describe VersionCake::QueryParameterStrategy do
  let(:strategy) { VersionCake::QueryParameterStrategy.new }
  subject { strategy.extract(request) }

  context "a request with an api_version parameter retrieves the version" do
    let(:request) { instance_double('Request', GET: {'api_version' => '11', 'other' => 'parameter'}) }

    it { is_expected.to eq 11 }
  end

  context "a request with an Integer api_version parameter retrieves the version" do
    let(:request) { instance_double('Request', GET: {'api_version' => 11, 'other' => 'parameter'}) }

    it { is_expected.to eq 11 }
  end

  context "a request without an api_version parameter returns nil" do
    let(:request) { instance_double('Request', GET: {'other' => 'parameter', 'another' => 'parameter'}) }

    it { is_expected.to be_nil }
  end
end
