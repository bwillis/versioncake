require 'action_view'

# register an addition detail for the lookup context to understand,
# this will allow us to have the versions available upon lookup in
# the resolver.
ActionView::LookupContext.register_detail(:versions){ VersionCake::Railtie.config.versioncake.supported_versions }

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
    pieces = File.basename(path).split(".")
    pieces.shift

    extension = pieces.pop
    if ActionPack::VERSION::MAJOR == 4
      unless extension
        message = "The file #{path} did not specify a template handler. The default is currently ERB, " \
                    "but will change to RAW in the future."
        ActiveSupport::Deprecation.warn message
      end
    end
    handler = ActionView::Template.handler_for_extension(extension)
    format  = get_format_from_pieces(pieces, (ActionPack::VERSION::MAJOR == 4 ? ActionView::Template::Types : Mime))

    [handler, format]
  end

  # If there are still pieces and we didn't find a valid format, we may
  # have a version in the extension, so try one more time to pop the format.
  def get_format_from_pieces(pieces, format_list)
    format = nil
    pieces.reverse.each do |piece|
      if ActionView::PathResolver::EXTENSIONS.is_a?(Hash) &&
          ActionView::PathResolver::EXTENSIONS.include?(:variants)
        piece = piece.split(ActionView::PathResolver::EXTENSIONS[:variants], 2).first # remove variant from format
      end

      format = format_list[piece]
      break unless format.nil?
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
