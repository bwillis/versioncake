require './spec/rails_helper'

describe RendersController, type: :controller do
  render_views

  before { set_request_version 2 }
  
  subject(:render_response) { get :index }

  it { expect(render_response.body).to eq 'template v2' }
end
