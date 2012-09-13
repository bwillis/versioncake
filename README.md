# Version Cake [![Build Status](https://secure.travis-ci.org/bwillis/versioncake.png?branch=master)](http://travis-ci.org/bwillis/versioncake)

Version Cake is a way to easily version views in your Rails app.

## Install

```
gem install versioncake
```

## How to use

### Configure

You need to define the supported versions in your Rails application.rb file as
```view_versions```. Use this config to set the range of supported API
versions that can be served:

```ruby
config.view_versions = [1,3,4,5] # or (1...5)
#config.view_version_extraction_strategy = :http_parameter # options = :http_header, :http_accept_parameter, :query_parameter, custom Proc
```

### Version your views

When a client makes a request to your controller the latest version of the
view will be rendered. The latest version is determined by naming the template
or partial with a version number that you configured to support.

```
- app/views/posts
    - index.html.erb
    - edit.html.erb
    - show.html.erb
    - show.json.jbuilder
    - show.v1.json.jbuilder
    - show.v2.json.jbuilder
    - new.html.erb
    - _form.html.erb
```

If you start supporting a newer version, v3 for instance, a request for the latest
version of posts/show will gracefully degrade to the latest support available
version, in this case posts/show.v2.json.jbuilder.

### Client requests

When a client makes a request it will automatically receive the latest supported
version of the view. The client can also request for a specific version by one of three
strategies configured by ``view_version_extraction_strategy``:

 - http_header: Api version HTTP header ie. ```API-Version: 1```
 - http_accept_parameter: HTTP Accept header ie. ```Accept: application/xml; version=1```
  - http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned
 - query_parameter: version in the url query parameter ie. ```http://localhost:3000/posts.json?api_version=1```

A custom strategy is available by providing a proc to the ``view_version_extraction_strategy`` configuration. It
takes a single parameter of the current request and must return an integer.

```ruby
Proc.new { |request| request.headers["HTTP_X_API_MAGIC"].to_i }
```

## Development Work

1. Finish convertion of Rspec tests to TestUnit
2. Syntatic sugar controller helpers to detect the version - interface discussion: https://github.com/bwillis/versioncake/commit/3dbdaf612ff99676c499a456f3e858e22382e76b#commitcomment-1847368
3. Log the version requested in the logs

# Similar Libraries

- https://github.com/bploetz/versionist

# License

Version Cake is released under the MIT license: www.opensource.org/licenses/MIT
