VersionCake.setup do |config|
  # Set the version key that clients will send example: `X-API-VERSION: 5`
  # config.version_key = 'version'

  # Enable Rails versioned filename mapping
  # config.rails_view_versioning = true

  # Extraction Strategies
  # Define how you will accept version from the request.
  #
  # Defaults to all:
  #   [:http_accept_parameter, :http_header, :request_parameter, :path_parameter, :query_parameter]
  #
  # Custom strategy example:
  #   You can create your own extraction strategy by giving a proc or class that responds to execute:
  # ```
  #     lambda {|request| request.headers["HTTP_X_MY_VERSION"] }
  # ```
  # or
  # ```
  # class ExtractorStrategy
  #   def execute(request)
  #     request.headers["HTTP_X_MY_VERSION"]
  #   end
  # end
  # ```
  # config.extraction_strategy = [:http_accept_parameter, :http_header, :request_parameter, :path_parameter, :query_parameter]

  # Version when no version in present in the request. If none is
  # specified then it will error?
  # config.missing_version = 5

  # Versioned Resources
  # Define what server resources are supported, deprecated or obsolete
  # Resources listed are priority based upon creation. To version all
  # resources you can define a catch all at the bottom of the block.
  config.resources do |r|
    # r.resource uri_regex, obsolete, deprecated, supported
    r.resource %r{.*}, [], [], (1..5)
  end
end

# TODO: Remove!

# Versioned resources are described by a URI pattern
# versioned_resources = {
#     * => {
#         supported: (1..LATEST)
#     }
#     %r{users} => {
#         obsolute: 2,
#         deprecated: 3,
#         supported: 4,
#         rewrite_uri: 'user'
#     },
#     %r{user} => {
#         supported: (5..LATEST)
#     }
# }
#
# v1/users => 404
# v2/users => 410 (GONE)
# v3/users => 'v3/user' with warning
# v4/users => 'v4/user'
# v5/users => 404
# v5/user => 'v5/user'
# v6/user => 'v6/user'
