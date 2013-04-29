require 'action_view'

# register an addition detail for the lookup context to understand,
# this will allow us to have the versions available upon lookup in
# the resolver.
ActionView::LookupContext.register_detail(:versions){ VersionCake::Configuration.supported_versions }

ActionView::PathResolver.class_eval do

  # not sure why we are doing this yet, but looks like a good idea
  ActionView::PathResolver::EXTENSIONS.replace [:locale, :versions, :formats, :handlers]

  # The query builder has the @details from the lookup_context and will
  # match the detail name to the string in the pattern, so we must append
  # it to the default pattern
  ActionView::PathResolver::DEFAULT_PATTERN.replace ":prefix/:action{.:locale,}{.:versions,}{.:formats,}{.:handlers,}"

end

ActionView::Template.class_eval do

  # the identifier method name filters out numbers,
  # but we want to preserve them for v1 etc.
  def identifier_method_name #:nodoc:
    inspect.gsub(/[^a-z0-9_]/, '_')
  end

end