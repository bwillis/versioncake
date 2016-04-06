VersionCake.setup do |config|
  # Versioned Resources
  # Define what server resources are supported, deprecated or obsolete
  # Resources listed are priority based upon creation. To version all
  # resources you can define a catch all at the bottom of the block.
  config.resources do |r|
    # r.resource uri_regex, obsolete, deprecated, supported
    r.resource %r{.*}, [], [], (1..5)
  end

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

  # Missing Version
  # What to use when no version in present in the request.
  #
  # Defaults to `:unversioned_template`
  #
  # Integer value:
  #   the version number to use
  #
  # `:unversioned_template` value:
  # If you are using `rails_view_versioning` this will render the "base template" aka
  # the template without a version number.
  # config.missing_version = :unversioned_template

  # Set the version key that clients will send example: `API-VERSION: 5`, api_version=2
  # config.version_key = 'api_version'

  # Enable Rails versioned filename mapping
  # config.rails_view_versioning = true

  # Response Strategies
  # Define how (if at all) to include the version in the response. Similar to how to retrieve the
  # version, you can set where it will be in the response. For example, the `http_header_strategy`
  # will include it the response header under the key configured in `config.version_key`.
  #
  # Defaults to none
  #
  # config.response_strategy = [] # [:http_content_type, :http_header]
end
