require './spec/rails_helper'

describe UnversionedController, type: :controller do
  subject(:response) { get :index }

  context '#index' do
    render_views

    it { expect(response).to be_successful }
    it { expect(response.body).to eq 'unversioned index' }
  end
end
