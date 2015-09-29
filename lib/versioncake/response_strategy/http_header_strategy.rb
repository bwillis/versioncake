module VersionCake
  module ResponseStrategy
    class HttpHeaderStrategy < Base
      def execute(context, _status, headers, _response)
        headers[header_key] = context.version.to_s
      end

      def header_key
        version_key.gsub('_', '-')
      end
    end
  end
end
