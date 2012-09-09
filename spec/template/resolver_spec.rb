require "spec_helper"

describe "Resolver" do

  it "extracts the correct handler and format from a versioned template" do
    resolver = ActionView::PathResolver.new
    handler, format = resolver.send "extract_handler_and_format", "/some/path/to/app/views/index.v1.xml.builder", nil
    handler.class.should == ActionView::Template::Handlers::Builder
    format.should == "application/xml"
  end

end