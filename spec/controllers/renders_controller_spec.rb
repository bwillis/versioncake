require 'spec_helper'
require 'action_view'

describe RendersController do

  render_views

  it "render the specified version of the partial" do
    ActionView::Template::Versions.supported_versions = [1,2]
    controller.request.stubs(:headers).returns({"version" => "1"})
    get :index
    response.body.should == "index.html.erb.v1!!!"
  end

end
