require 'action_view'

# register an addition detail for the lookup context to understand,
# this will allow us to have the versions available upon lookup in
# the resolver.
ActionView::LookupContext.register_detail(:versions){ VersionCake::Configuration.supported_versions }

ActionView::PathResolver.class_eval do
  # not sure why we are doing this yet, but looks like a good idea
  if ActionPack::VERSION::MAJOR >= 4 && ActionPack::VERSION::MINOR >= 1
    ActionView::PathResolver::EXTENSIONS.replace({
                                                     :locale => ".",
                                                     :formats => ".",
                                                     :versions => ".",
                                                     :variants => "+",
                                                     :handlers => "."
                                                 })

    ActionView::PathResolver::DEFAULT_PATTERN.replace ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:versions,}{.:handlers,}"
  else
    ActionView::PathResolver::EXTENSIONS.replace [:locale, :formats, :versions, :handlers]

    # The query builder has the @details from the lookup_context and will
    # match the detail name to the string in the pattern, so we must append
    # it to the default pattern
    ActionView::PathResolver::DEFAULT_PATTERN.replace ":prefix/:action{.:locale,}{.:formats,}{.:versions,}{.:handlers,}"
  end

  # The default extract handler expects that the handler is the last extension and
  # the format is the next one. Since we are replacing the DEFAULT_PATTERN, we need to
  # make sure that we extract the format from the correct position.
  #
  # The version may be stuck inbetween the format and the handler. This is actually pretty tricky
  # because the version is optional and the locale is optional-which means when there are 3 'pieces'
  # it may be the locale, format and handler or the format, version and handler. To check this, we will
  # try one additional time if there are more pieces, which should cover all the cases:
  #
  # Cases:
  #  1: assume version is in the extension, pieces = ['html','erb']
  #  2: assume version is in the extension, pieces = ['html','v1','erb']
  #  3: assume version is in the extension, pieces = ['en','html','erb']
  #  4: assume version is in the extension, pieces = ['en','html','v1','erb']
  #
  def extract_handler_and_format(path, default_formats)
    if ActionPack::VERSION::MAJOR == 4
      pieces = File.basename(path).split(".")
      pieces.shift

      extension = pieces.pop
      unless extension
        message = "The file #{path} did not specify a template handler. The default is currently ERB, " \
                    "but will change to RAW in the future."
        ActiveSupport::Deprecation.warn message
      end

      handler = ActionView::Template.handler_for_extension(extension)
      format  = get_format_from_pieces(pieces, ActionView::Template::Types)

      [handler, format]
    else # Rails < 4.1
      pieces = File.basename(path).split(".")
      pieces.shift
      handler = ActionView::Template.handler_for_extension(pieces.pop)
      format  = get_format_from_pieces(pieces, Mime)
      [handler, format]
    end
  end

  # If there are still pieces and we didn't find a valid format, we may
  # have a version in the extension, so try one more time to pop the format.
  def get_format_from_pieces(pieces, format_list)
    format = pieces.last && format_list[pieces.pop]
    if format.nil? && pieces.length > 0
      format = pieces.last && format_list[pieces.pop]
    end
    format
  end
end

ActionView::Template.class_eval do
  # the identifier method name filters out numbers,
  # but we want to preserve them for v1 etc.
  def identifier_method_name #:nodoc:
    inspect.gsub(/[^a-z0-9_]/, '_')
  end
end
