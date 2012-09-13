require 'spec_helper'

describe RendersController do

  render_views

  before do
    ActionView::Template::Versions.extraction_strategy = :query_parameter
  end

  it "render the latest version of the partial" do
    get :index
    response.body.should == "index.v2.html.erb"
  end

  it "exposes the requested version" do
    get :index, "api_version" => "1"
    controller.requested_version.should == 1
  end

  it "exposes latest version when requesting the latest" do
    get :index, "api_version" => "4"
    controller.is_latest_version.should be
  end

  it "reports not the latest version" do
    get :index, "api_version" => "1"
    controller.is_latest_version.should_not be
  end

  context "parameter strategy" do
    before do
      ActionView::Template::Versions.extraction_strategy = :query_parameter
    end

    it "renders version 1 of the partial based on the parameter _api_version" do
      get :index, "api_version" => "1"
      response.body.should == "index.v1.html.erb"
    end

    it "renders version 2 of the partial based on the parameter _api_version" do
      get :index, "api_version" => "2"
      response.body.should == "index.v2.html.erb"
    end

    it "renders the latest available version (v2) of the partial based on the parameter _api_version" do
      get :index, "api_version" => "3"
      response.body.should == "index.v2.html.erb"
    end
  end

  context "custom header strategy" do
    before do
      ActionView::Template::Versions.extraction_strategy = :http_header
    end

    it "renders version 1 of the partial based on the header API-Version" do
      controller.request.stubs(:headers).returns({"HTTP_API_VERSION" => "1"})
      get :index
      response.body.should == "index.v1.html.erb"
    end

    it "renders version 2 of the partial based on the header API-Version" do
      controller.request.stubs(:headers).returns({"HTTP_API_VERSION" => "2"})
      get :index
      response.body.should == "index.v2.html.erb"
    end

    it "renders the latest available version (v2) of the partial based on the header API-Version" do
      controller.request.stubs(:headers).returns({"HTTP_API_VERSION" => "3"})
      get :index
      response.body.should == "index.v2.html.erb"
    end
  end

  context "accept header strategy" do
    before do
      ActionView::Template::Versions.extraction_strategy = :http_accept_parameter
    end

    it "renders version 1 of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=1"})
      get :index
      response.body.should == "index.v1.html.erb"
    end

    it "renders version 2 of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=2"})
      get :index
      response.body.should == "index.v2.html.erb"
    end

    it "renders the latest available version (v2) of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=3"})
      get :index
      response.body.should == "index.v2.html.erb"
    end

    it "renders the latest version of the partial" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=abc"})
      get :index
      response.body.should == "index.v2.html.erb"
    end
  end

  context "accepts a custom strategy" do
    before do
      ActionView::Template::Versions.extraction_strategy = lambda { |request| 2 }
    end

    it "renders version 2 of the partial based on the header Accept" do
      get :index
      response.body.should == "index.v2.html.erb"
    end
  end

  context "accepts multiple strategies" do
    before do
      ActionView::Template::Versions.extraction_strategy = [:http_accept_parameter, :query_parameter]
    end

    it "renders version 1 of the partial based on the header Accept" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=1"})
      get :index
      response.body.should == "index.v1.html.erb"
    end

    it "renders the query parameter when accept parameter isn't available" do
      get :index, "api_version" => "1"
      response.body.should == "index.v1.html.erb"
    end

    it "renders the higher priority accept parameter version" do
      controller.request.stubs(:headers).returns({"HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8;api_version=2"})
      get :index, "api_version" => "1"
      response.body.should == "index.v2.html.erb"
    end
  end
end