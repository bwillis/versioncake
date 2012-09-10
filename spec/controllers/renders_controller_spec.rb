require 'spec_helper'

describe RendersController do

  render_views

  it "render the latest version of the partial" do
    get :index
    response.body.should == "index.v2.html.erb"
  end

  context "parameter strategy" do
    it "render version 1 of the partial based on the parameter _api_version" do
      get :index, "_api_version" => "1"
      response.body.should == "index.v1.html.erb"
    end

    it "render version 2 of the partial based on the parameter _api_version" do
      get :index, "_api_version" => "2"
      response.body.should == "index.v2.html.erb"
    end

    it "render the latest available version (v2) of the partial based on the parameter _api_version" do
      get :index, "_api_version" => "3"
      response.body.should == "index.v2.html.erb"
    end
  end

  context "custom header strategy" do
    it "render version 1 of the partial based on the header API-Version" do
      controller.request.stubs(:headers).returns({"HTTP_API_VERSION" => "1"})
      get :index
      response.body.should == "index.v1.html.erb"
    end

    it "render version 2 of the partial based on the header API-Version" do
      controller.request.stubs(:headers).returns({"HTTP_API_VERSION" => "2"})
      get :index
      response.body.should == "index.v2.html.erb"
    end

    it "render the latest available version (v2) of the partial based on the header API-Version" do
      controller.request.stubs(:headers).returns({"HTTP_API_VERSION" => "3"})
      get :index
      response.body.should == "index.v2.html.erb"
    end
  end

  context "accept header strategy" do
    it "render version 1 of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;version=1"})
      get :index
      response.body.should == "index.v1.html.erb"
    end

    it "render version 2 of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;version=2"})
      get :index
      response.body.should == "index.v2.html.erb"
    end

    it "render the latest available version (v2) of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;version=3"})
      get :index
      response.body.should == "index.v2.html.erb"
    end
  end
end