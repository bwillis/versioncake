require 'action_view'

ActionView::LookupContext.class_eval do

  # register an addition detail for the lookup context to understand,
  # this will allow us to have the versions available upon lookup in
  # the resolver.
  register_detail(:versions){ ActionView::Template::Versions.supported_versions }

end