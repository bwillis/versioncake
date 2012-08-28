require "spec_helper"
require 'action_controller'
require 'action_view'
require 'action_dispatch'

class TestController < ActionController::Base
  def versioned_partial
  end
end

describe "RenderTestCases" do

  before do
    path = ActionView::FileSystemResolver.new(FIXTURE_LOAD_PATH)
    view_paths = ActionView::PathSet.new([path])
    @view = ActionView::Base.new(view_paths,{})
    ActionView::Template::Versions.supported_versions = [3,2,1]
  end

  it "renders the legacy version of the partial" do
    @view.lookup_context.versions = [:v2]
    @view.render(:template => "partials/versioned_partial").should == "partial version 2"
  end

  it "renders the latest available version of the requested partial" do
    @view.lookup_context.versions = [:v4,:v3,:v2,:v1]
    @view.render(:template => "partials/versioned_partial").should == "partial version 3"
  end

  it "renders the latest version of the partial" do
    @view.render(:template => "partials/versioned_partial").should == "partial version 3"
  end

  it "renders the unversioned partial (regression)" do
    @view.render(:template => "partials/partial").should == "partial"
  end

  it "renders the overridden version of the partial" do
    @view.render(:template => "partials/versioned_partial", :versions => :v1).should == "partial version 1"
  end

  it "render the specified version of the partial" do
    controller.request.stub(:headers).returns({"version" => "1"})
    get :versioned_partial
    response.should render_template("versioned_partial.v1")
  end
end
