require 'action_view'

ActionView::PathResolver.class_eval do

  # not sure why we are doing this yet, but looks like a good idea
  ActionView::PathResolver::EXTENSIONS.replace [:locale, :versions, :formats, :handlers]

  # The query builder has the @details from the lookup_context and will
  # match the detail name to the string in the pattern, so we must append
  # it to the default pattern
  ActionView::PathResolver::DEFAULT_PATTERN.replace ":prefix/:action{.:locale,}{.:versions,}{.:formats,}{.:handlers,}"

end