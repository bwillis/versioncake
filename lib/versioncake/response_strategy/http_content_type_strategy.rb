module VersionCake
  module ResponseStrategy
    class HttpContentTypeStrategy < Base
      def execute(context, _status, headers, _response)
        return if headers['Content-Type'].nil?

        content_type = headers['Content-Type']
        content_type << ';' unless headers['Content-Type'].end_with?(';')

        headers['Content-Type'] = "#{content_type} #{version_key}=#{context.version.to_s}"
      end
    end
  end
end
