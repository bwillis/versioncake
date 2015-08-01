require 'spec_helper'

describe VersionCake::HttpHeaderStrategy do
  let(:strategy) { VersionCake::HttpHeaderStrategy.new }
  subject { strategy.extract(request) }

  context "a request with an HTTP_X_API_VERSION retrieves the version" do
    let(:request) { instance_double('Request', env: {'HTTP_API_VERSION' => '11'}) }

    it { is_expected.to eq 11 }
  end

  context "a request without an HTTP_X_API_VERSION returns nil" do
    let(:request) { instance_double('Request', \
      env: {'HTTP_ACCEPT' => 'text/x-dvi; q=.8; mxb=100000; mxt=5.0, text/x-c'}) }

    it { is_expected.to be_nil }
  end
end
