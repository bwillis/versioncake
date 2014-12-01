require 'spec_helper'
require 'rails_helper'

describe RendersController, type: :controller do
  render_views
  let(:request_options) { {} }
  subject(:response) { get :index, request_options }

  context 'with a version in the accept header' do
    before { allow(request).to receive(:headers).and_return({'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=1'}) }

    it { expect(response.body).to eq 'template v1' }
  end

  context 'when query parameter sets the version' do
    let(:request_options) { { 'api_version' => '1' } }

    it 'renders the query parameter when accept parameter isn\'t available' do
      expect(response.body).to eq 'template v1'
    end
  
    context 'and the accept header sets the version' do
      before { allow(request).to receive(:headers).and_return({'HTTP_ACCEPT' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=2'}) }

      it 'renders the higher priority accept parameter version' do
        expect(response.body).to eq 'template v2'
      end
    end
  end
end
