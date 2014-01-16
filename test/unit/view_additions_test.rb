require './test/test_helper'

class ViewAdditionsTest < ActiveSupport::TestCase
  setup do
    @resolver = ActionView::PathResolver.new
  end

  test "it retrieves the correct handler and format when only hanlder and format are present" do
    handler, format = @resolver.extract_handler_and_format('application.html.erb', nil)
    assert_equal format.to_s, 'text/html'
  end

  test "it retrieves the correct handler and format when only hanlder, format and version are present" do
    handler, format = @resolver.extract_handler_and_format('application.json.v1.jbuilder', nil)
    assert_equal format.to_s, 'application/json'
  end

  test "it retrieves the correct handler and format when only hanlder, format and locale are present" do
    handler, format = @resolver.extract_handler_and_format('application.en.json.jbuilder', nil)
    assert_equal format.to_s, 'application/json'
  end

  test "it retrieves the correct handler and format when only hanlder, format, locale and version are present" do
    handler, format = @resolver.extract_handler_and_format('application.en.json.v1.jbuilder', nil)
    assert_equal format.to_s, 'application/json'
  end
end
