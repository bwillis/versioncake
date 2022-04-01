require 'action_view'

# register an addition detail for the lookup context to understand,
# this will allow us to have the versions available upon lookup in
# the resolver.
ActionView::LookupContext.register_detail(:versions){ [] }

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
          (?:\+(?<variant>#{variants}))??
          (?:\.(?<versions>v[0-9]+))??
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
      @variants_idx = ANY_HASH
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

