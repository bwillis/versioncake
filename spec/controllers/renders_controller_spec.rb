require 'spec_helper'

describe RendersController do

  render_views

  it "render the specified version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "1"})
    get :index
    response.body.should == "index.html.erb.v1!!!"
  end

end
