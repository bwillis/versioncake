require './spec/spec_helper'

describe VersionCake::PathParameterStrategy do
  let(:strategy) { VersionCake::PathParameterStrategy.new }
  subject { strategy.extract(request) }

  context "a request with an api_version path parameter retrieves the version" do
    let(:request) { instance_double('Request', path_parameters: \
      {api_version: '11', other: 'parameter'}) }

    it { is_expected.to eq 11 }
  end

  context "a request without an api_version path parameter returns nil" do
    let(:request) { instance_double('Request', path_parameters: \
      {other: 'parameter', another: 'parameter'}) }

    it { is_expected.to be_nil }
  end
end
