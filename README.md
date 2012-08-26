# Render Version

Render version is a way to easily enable versioned views to support
mulitple clients.

## Install

```
gem install renderversion # TBD
```

## How to use

When installed, render version will hook into the render function. When
a client requests a version it will automatically look for that version
by the file name. If the client requests version 2, it will attempt to
render  ```show.html.erb.v2```. It will gracefully degrade to a lower
version number or to the default base template without a version number.

The client requests for a version based on an HTTP Header API_VERSION.
Without this the rendering will default to the latest version.

You need to define the supported version numbers in the application
configuration ```view_versions```. Use this config to set the range of supported API
versions, for instance [5..1], or [5..3].

## Development Work

1. Set the initial version list to a configuration parameter when
   registerting the detail in lookup_context.rb
2. Detect if there is an API_VERSION header and set the lookup context
   versions to that value

# License

RenderVersion is released under the MIT license: www.opensource.org/licenses/MIT
