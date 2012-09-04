require 'spec_helper'

describe RendersController do

  it "render the specified version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "1"})
    get :index
    response.should render_template("versioned_partial.v1")
  end

end
