require 'spec_helper'
require 'rails_helper'

describe RendersController, type: :controller do
  render_views
  
  before do
    allow_any_instance_of(VersionCake::Configuration).to \
      receive(:extraction_strategy).and_return(lambda { |_| 2 })
  end
  
  subject(:render_response) { get :index }

  it { expect(render_response.body).to eq 'template v2' }
end
