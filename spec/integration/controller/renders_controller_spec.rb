require './spec/rails_helper'

describe RendersController, type: :controller do
  let(:request_options) { {} }
  subject(:response_body) { get :index, request_options; response.body }

  context '#index' do
    render_views
    before { set_request_version 'renders', request_version }
    before { response_body }

    context 'when requesting the non latest version' do
      let(:request_version) { 1 }

      it { expect(controller.request_version).to eq 1 }
      it { expect(controller.is_latest_version?).to be_falsey }
      it { expect(controller.is_deprecated_version?).to be_falsey }
      it { expect(response_body).to eq 'template v1' }
    end

    context 'when explicitly requesting the latest version' do
      let(:request_version) { 5 }

      it { expect(controller.request_version).to eq 5 }
      it { expect(controller.is_latest_version?).to be_truthy }
      it { expect(controller.is_deprecated_version?).to be_falsey }
      it { expect(response_body).to eq 'template v2' }
    end

    context 'when requesting a deprecated version' do
      let(:request_version) { 4 }

      it { expect(controller.request_version).to eq 4 }
      it { expect(controller.is_latest_version?).to be_falsey }
      it { expect(controller.is_deprecated_version?).to be_truthy }
      it { expect(response_body).to eq 'template v2' }
    end

    context '#set_version' do
      let(:request_options) { { 'override_version' => 2 } }
      let(:request_version) { 3 }

      it { expect(controller.request_version).to eq 2 }
      it { expect(response_body).to eq 'template v2' }
    end
  end

  context 'errors' do
    context 'with a version larger than the supported versions' do
      before { set_version_context :version_too_high }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with a version lower than the supported versions' do
      before { set_version_context :version_too_low }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with an invalid version' do
      before { set_version_context :version_invalid }

      it { expect { response_body }.to raise_error VersionCake::UnsupportedVersionError }
    end

    context 'with an obsolete version' do
      before { set_version_context :obsolete }

      it { expect { response_body }.to raise_error VersionCake::ObsoleteVersionError }
    end
  end
end
