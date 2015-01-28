require './spec/rails_helper'

describe RendersController, type: :controller do
  before { set_request_version 3 }
  let(:request_options) { {} }
  subject(:response_body) { get :index, request_options; response.body }

  context '#index' do
    before { response_body }

    context 'with version 1 requested' do
      before { set_request_version 1, :supported, [1,2] }

      it { expect(controller.request_version).to eq 1 }
      it { expect(controller.is_latest_version?).to be_falsey }
    end

    context 'with explicity requesting the latest version' do
      before { set_request_version 3 }

      it { expect(controller.request_version).to eq 3 }
      it { expect(controller.is_latest_version?).to be_truthy }
    end

    context '#set_version' do
      let(:request_options) { { 'override_version' => 2 } }
      before { set_request_version 3 }

      it { expect(controller.request_version).to eq 2 }
    end
  end

  context 'errors' do
    context 'with a version larger than the supported versions' do
      before { set_request_version :version_too_high }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with a version lower than the supported versions' do
      before { set_request_version :version_too_low }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with an invalid version' do
      before { set_request_version :version_invalid }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end
  end
end
