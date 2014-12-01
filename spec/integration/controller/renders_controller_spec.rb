require 'spec_helper'
require 'rails_helper'

describe RendersController, type: :controller do
  before { allow_any_instance_of(VersionCake::Configuration).to receive(:default_version).and_return(default_version) }
  let(:default_version) { 3 }
  subject(:response_body) { get :index, request_options; response.body }

  context '#index' do
    before { response_body }

    context 'with no version requested' do
      render_views

      let(:request_options) { {} }

      it { expect(response_body).to eq 'template v2' }
      it { expect(controller.requested_version).to be_blank }
      it { expect(controller.derived_version).to eq 3 }

      context 'and the default version is set to 1' do
        let(:default_version) { 1 }

        it { expect(controller.derived_version).to eq 1 }
      end
    end

    context 'with version 1 requested' do
      let(:request_options) { {'api_version' => '1'} }

      it { expect(controller.requested_version).to eq 1 }
      it { expect(controller.is_latest_version).to be_falsey }
    end

    context 'with explicity requesting the latest version' do
      let(:request_options) { {'api_version' => '3'} }

      it { expect(controller.requested_version).to eq 3 }
      it { expect(controller.is_latest_version).to be_truthy }
    end

    context '#set_version' do
      let(:request_options) { {'api_version' => '1', 'override_version' => 2} }

      it { expect(controller.derived_version).to eq 2 }
    end
  end

  context 'errors' do
    context 'with a version larger than the supported versions' do
      let(:request_options) { {'api_version' => '4'} }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with an available version' do
      let(:request_options) { {'api_version' => '0'} }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with an invalid version' do
      let(:request_options) { {'api_version' => 'abc'} }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end
  end

  context 'when derived_version is called before the before_filter' do
    before do
      controller.instance_variable_set('@_lookup_context', double(:versions= => nil))
      allow(request).to receive(:query_parameters).and_return({:api_version => '2'})
    end

    it { expect(controller.derived_version).to eq 2 }
  end
end
