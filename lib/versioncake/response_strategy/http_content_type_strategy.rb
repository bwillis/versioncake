module VersionCake
  module ResponseStrategy
    class HttpContentTypeStrategy < Base
      def execute(context, _status, headers, _response)
        return if headers['Content-Type'].nil?

        headers['Content-Type'] << ';' unless headers['Content-Type'].end_with? ';'
        headers['Content-Type'] << " #{version_key}=#{context.version.to_s}"
      end
    end
  end
end
