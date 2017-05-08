require './spec/rails_helper'

describe RendersController, type: :controller do
  subject(:response_body) { get :index; response.body }

  context '#index' do
    render_views
    let(:config) { VersionCake.config }
    before { set_request_version 'renders', request_version, config }
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

    context 'when requesting without a version' do
      context 'and missing version is configured to unversioned_template' do
        let(:request_version) { nil }

        # TODO: Restructure
        # Need a better way to stub/unstub the `VersionCake.config` that generates
        # the context and is used in the controller.
        let(:config) do
          VersionCake.config.tap do |config|
            config.missing_version = :unversioned_template
          end
        end
        after { VersionCake.config.missing_version = nil }
        # /TODO

        it { expect(controller.request_version).to eq nil }
        it { expect(controller.is_latest_version?).to be_falsey }
        it { expect(controller.is_deprecated_version?).to be_falsey }
        it { expect(response_body).to eq 'base template' }
      end
    end

    context '#set_version' do
      params_style = if ActionPack::VERSION::MAJOR >= 5
        { params: { override_version: 1 } }
      else
        { override_version: 1 }
      end
      subject(:response_body) { get :index, params_style; response.body }
      let(:request_version) { 3 }

      it { expect(controller.request_version).to eq 1 }
      it { expect(response_body).to eq 'template v1' }
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
