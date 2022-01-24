require 'action_view'

# register an addition detail for the lookup context to understand,
# this will allow us to have the versions available upon lookup in
# the resolver.
ActionView::LookupContext.register_detail(:versions){ [] }

if ActionPack::VERSION::MAJOR >= 7
  ActionView::Resolver::PathParser.class_eval do
    def build_path_regex
      handlers = ActionView::Template::Handlers.extensions.map { |x| Regexp.escape(x) }.join("|")
      formats = ActionView::Template::Types.symbols.map { |x| Regexp.escape(x) }.join("|")
      locales = "[a-z]{2}(?:-[A-Z]{2})?"
      variants = "[^.]*"

      %r{
          \A
          (?:(?<prefix>.*)/)?
          (?<partial>_)?
          (?<action>.*?)
          (?:\.(?<locale>#{locales}))??
          (?:\.(?<format>#{formats}))??
          (?:\.(?<versions>v[0-9]+))??
          (?:\+(?<variant>#{variants}))??
          (?:\.(?<handler>#{handlers}))?
          \z
        }x
    end

    def parse(path)
      @regex ||= build_path_regex
      match = @regex.match(path)
      path = ActionView::TemplatePath.build(match[:action], match[:prefix] || "", !!match[:partial])
      details = ActionView::TemplateDetails.new(
        match[:locale]&.to_sym,
        match[:handler]&.to_sym,
        match[:format]&.to_sym,
        match[:variant]&.to_sym,
        match[:versions]&.to_sym,
      )

      ActionView::Resolver::PathParser::ParsedPath.new(path, details)
    end
  end

  ActionView::TemplateDetails::Requested.class_eval do
    attr_reader :locale, :handlers, :formats, :variants, :versions
    attr_reader :locale_idx, :handlers_idx, :formats_idx, :variants_idx, :versions_idx

    def initialize(locale:, handlers:, formats:, variants:, versions:)
      @locale = locale
      @handlers = handlers
      @formats = formats
      @variants = variants
      @versions = versions

      @locale_idx   = build_idx_hash(locale)
      @handlers_idx = build_idx_hash(handlers)
      @formats_idx  = build_idx_hash(formats)
      @versions_idx  = build_idx_hash(versions)
      if variants == :any
        @variants_idx = ActionView::TemplateDetails::Requested::ANY_HASH
      else
        @variants_idx = build_idx_hash(variants)
      end
    end
  end

  ActionView::TemplateDetails.class_eval do
    attr_reader :locale, :handler, :format, :variant, :version

    def initialize(locale, handler, format, variant, version)
      @locale = locale
      @handler = handler
      @format = format
      @variant = variant
      @version = version
    end

    def matches?(requested)
      requested.formats_idx[@format] &&
        requested.locale_idx[@locale] &&
        requested.versions_idx[@version] &&
        requested.variants_idx[@variant] &&
        requested.handlers_idx[@handler]
    end

    def sort_key_for(requested)
      [
        requested.formats_idx[@format],
        requested.locale_idx[@locale],
        requested.versions_idx[@version],
        requested.variants_idx[@variant],
        requested.handlers_idx[@handler]
      ]
    end
  end

  ActionView::UnboundTemplate.class_eval do
    delegate :version, to: :@details

    def build_template(locals)
      ActionView::Template.new(
        @source,
        @identifier,
        details.handler_class,

        format: details.format_or_default,
        variant: variant&.to_s,
        virtual_path: @virtual_path,
        version: version&.to_s,

        locals: locals.map(&:to_s)
      )
    end
  end

  ActionView::Template.class_eval do
    def initialize(source, identifier, handler, locals:, format: nil, variant: nil, virtual_path: nil, version: nil)
      @source            = source
      @identifier        = identifier
      @handler           = handler
      @compiled          = false
      @locals            = locals
      @virtual_path      = virtual_path

      @variable = if @virtual_path
        base = @virtual_path.end_with?("/") ? "" : ::File.basename(@virtual_path)
        base =~ /\A_?(.*?)(?:\.\w+)*\z/
        $1.to_sym
      end

      @format            = format
      @version           = version
      @variant           = variant
      @compile_mutex     = Mutex.new
    end

    def marshal_dump # :nodoc:
      [ @source, @identifier, @handler, @compiled, @locals, @virtual_path, @format, @variant, @version ]
    end

    def marshal_load(array) # :nodoc:
      @source, @identifier, @handler, @compiled, @locals, @virtual_path, @format, @variant, @version = *array
      @compile_mutex = Mutex.new
    end

    # the identifier method name filters out numbers,
    # but we want to preserve them for v1 etc.
    # TODO: Consider updating to match current implementation:
    # short_identifier.tr("^a-z_", "_")
    def identifier_method_name #:nodoc:
      short_identifier.gsub(/[^a-z0-9_]/, '_')
    end
  end
else
  ActionView::PathResolver.class_eval do
    if ActionPack::VERSION::MAJOR >= 6
      ActionView::PathResolver::EXTENSIONS.replace({
        locale: ".",
        formats: ".",
        versions: ".",
        variants: "+",
        handlers: "."
      })
      Kernel::silence_warnings {
        ActionView::PathResolver::DEFAULT_PATTERN = ":prefix/:action{.:locale,}{.:formats,}{.:versions,}{+:variants,}{.:handlers,}"
      }
    elsif ActionPack::VERSION::MAJOR >= 4 && ActionPack::VERSION::MINOR >= 1 || ActionPack::VERSION::MAJOR >= 5
      ActionView::PathResolver::EXTENSIONS.replace({
                                                       locale: ".",
                                                       formats: ".",
                                                       versions: ".",
                                                       variants: "+",
                                                       handlers: "."
                                                   })

      def initialize(pattern = nil)
        @pattern = pattern || ":prefix/:action{.:locale,}{.:formats,}{+:variants,}{.:versions,}{.:handlers,}"
        super()
      end
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
end
