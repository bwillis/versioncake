require "./test/test_helper"

class VersionRenderTest < ActiveSupport::TestCase

  def setup
    path = ActionView::FileSystemResolver.new(FIXTURE_LOAD_PATH)
    view_paths = ActionView::PathSet.new([path])
    @view = ActionView::Base.new(view_paths)
  end

  def test_regression_renders_unversioned_template
    @view.lookup_context.versions = [:v0]
    assert_equal "template", @view.render(:template => "templates/versioned")
  end

  def test_render_template_defaults_to_latest_template_version
    assert_equal "template v3", @view.render(:template => "templates/versioned")
  end

  def test_render_template_with_parameter_version_override
    assert_equal "template v1", @view.render(:template => "templates/versioned", :versions => :v1)
  end

  def test_render_template_with_legacy_version
    @view.lookup_context.versions = [:v2]
    assert_equal "template v2", @view.render(:template => "templates/versioned")
  end

  def test_render_template_gracefully_degrades
    @view.lookup_context.versions = [:v4,:v3,:v2,:v1]
    assert_equal "template v3", @view.render(:template => "templates/versioned")
  end

end