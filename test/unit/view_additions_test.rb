require './test/test_helper'

class ViewAdditionsTest < ActiveSupport::TestCase
  setup do
    @resolver = ActionView::PathResolver.new
  end

  test "it retrieves the correct handler and format when only handler and format are present" do
    handler, format = @resolver.extract_handler_and_format('application.html.erb', nil)
    assert_equal 'text/html', format.to_s
  end

  test "it retrieves the correct handler and format when only handler, format and version are present" do
    handler, format = @resolver.extract_handler_and_format('application.json.v1.jbuilder', nil)
    assert_equal 'application/json', format.to_s
  end

  test "it retrieves the correct handler and format when only handler, format and locale are present" do
    handler, format = @resolver.extract_handler_and_format('application.en.json.jbuilder', nil)
    assert_equal 'application/json', format.to_s
  end

  test "it retrieves the correct handler and format when only handler, format, locale and version are present" do
    handler, format = @resolver.extract_handler_and_format('application.en.json.v1.jbuilder', nil)
    assert_equal 'application/json', format.to_s
  end

  if ActionPack::VERSION::MAJOR == 4 && ActionPack::VERSION::MINOR >= 1
    test "it retrieves the correct handler and format when only handler, format, variant and version are present" do
      handler, format = @resolver.extract_handler_and_format('application.json+tablet.v1.jbuilder', nil)
      assert_equal 'application/json', format.to_s
    end
  end

end
