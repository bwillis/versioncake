require 'spec_helper'
require 'action_view'

describe RendersController do

  it "render the specified version of the partial" do
    controller.request.stubs(:headers).returns({"version" => "1"})
    get :index
    response.should render_template("renders/index.v1")
  end

end
