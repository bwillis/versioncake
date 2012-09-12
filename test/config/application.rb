require 'rails/all'

module RendersTest
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.active_support.deprecation = :stderr
    config.view_versions = (1..3)
    config.view_version_extraction_strategy = :http_header
  end
end
