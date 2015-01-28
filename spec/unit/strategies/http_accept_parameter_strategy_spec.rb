require 'spec_helper'

describe VersionCake::HttpAcceptParameterStrategy do
  let(:strategy) { VersionCake::HttpAcceptParameterStrategy.new }
  subject { strategy.extract(request) }

  context "a request with an HTTP_ACCEPT version retrieves the version" do
    let(:request) { instance_double('Request', env: \
      {'HTTP_ACCEPT' => 'application/xml; api_version=11'}) }

    it { is_expected.to eq 11 }
  end

  context "a request without an HTTP_ACCEPT version returns nil" do
    let(:request) { instance_double('Request', env: \
      {'HTTP_ACCEPT' => 'text/x-dvi; q=.8; mxb=100000; mxt=5.0, text/x-c'}) }

    it { is_expected.to be_nil }
  end
end
