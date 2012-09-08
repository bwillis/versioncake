require "spec_helper"
require 'action_controller'
require 'action_view'
require 'action_dispatch'

describe "RenderTestCases" do

  before do
    path = ActionView::FileSystemResolver.new(FIXTURE_LOAD_PATH)
    view_paths = ActionView::PathSet.new([path])
    @view = ActionView::Base.new(view_paths,{})
  end

  it "renders the unversioned template (regression)" do
    @view.render(:template => "templates/versioned").should == "template"
  end

  it "renders the latest version of the template" do
    @view.render(:template => "templates/versioned").should == "template v3"
  end

  it "renders the overridden version of the template" do
    @view.render(:template => "templates/versioned", :versions => :v1).should == "template v1"
  end

  it "renders the legacy version of the template" do
    @view.lookup_context.versions = [:v2]
    @view.render(:template => "templates/versioned").should == "template v2"
  end

  it "renders the latest available version of the requested template" do
    @view.lookup_context.versions = [:v4,:v3,:v2,:v1]
    @view.render(:template => "templates/versioned").should == "template v3"
  end

end
