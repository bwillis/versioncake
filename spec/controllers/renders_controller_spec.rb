require 'spec_helper'
require 'action_view'

describe RendersController do

  before do
    ActionView::LookupContext.class_eval do

      # register an addition detail for the lookup context to understand,
      # this will allow us to have the versions available upon lookup in
      # the resolver.
      register_detail(:versions){ [:v1] }
      #register_detail(:version){ [] }

    end
  end
  it "render the specified version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "1"})
    get :index
    puts "response.body: #{response.body}"
    response.should render_template("renders/index.v1")
  end

end
