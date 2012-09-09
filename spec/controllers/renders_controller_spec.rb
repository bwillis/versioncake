require 'spec_helper'

describe RendersController do

  render_views

  it "render the latest version of the partial" do
    get :index
    response.body.should == "index.v2.html.erb"
  end

  it "render the specified version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "1"})
    get :index
    response.body.should == "index.v1.html.erb"
  end

  it "render the specified version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "2"})
    get :index
    response.body.should == "index.v2.html.erb"
  end

  it "render the latest supported version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "3"})
    get :index
    response.body.should == "index.v2.html.erb"
  end
end