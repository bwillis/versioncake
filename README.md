# Version Cake [![Build Status](https://secure.travis-ci.org/bwillis/versioncake.png?branch=master)](http://travis-ci.org/bwillis/versioncake)

Co-authored by Ben Willis ([@bwillis](https://github.com/bwillis/)) and Jim Jones ([@aantix](https://github.com/aantix)).

Version Cake is unobtrusive way to version views in your Rails app. 

We were tired of urls with version numbers, namespacing controllers with versions, and bumping all resources everytime we supported a new version. Simply configure your supported version numbers, create a versioned view if you need one and let versioncake render the requested version or gracefully degrade to the latest supported view version.

## Install

```
gem install versioncake
```

## How to use

### Configuration

You need to define the supported versions in your Rails application.rb file as ```view_versions```. Use this config to set the range of supported API versions that can be served:

```ruby
config.view_versions = [1,3,4,5] # or (1...5)
```
You can also define the way to extract the version. The ```view_version_extraction_strategy``` allows you to set one of the default strategies or provide a proc to set your own. You can also pass it a prioritized array of the strategies.
```ruby
config.view_version_extraction_strategy = :http_parameter # [:http_header, :http_accept_parameter, :query_parameter]
```
These are the default strategies:
 - **http_header**: Api version HTTP header ie. ```API-Version: 1```
 - **http_accept_parameter**: HTTP Accept header ie. ```Accept: application/xml; version=1``` [why do this?](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned)
 - **query_parameter**: version in the url query parameter, for testing or to override for special case ie. ```http://localhost:3000/posts.json?api_version=1```
 - **custom**: `lambda {|request| request.headers["HTTP_X_API_VERSION"].to_i }` takes the request object and must return an integer

### Version your views

When a client makes a request to your controller the latest version of the view will be rendered. The latest version is determined by naming the template or partial with a version number that you configured to support.

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

If you start supporting a newer version, v3 for instance, you do not have to copy show.v2 to show.v3. By default, the request for v3 or higher will gracefully degrade to the view that is the newest, supported version, in this case posts/show.v2.json.jbuilder.

### Controller

You don't need to do anything special in your controller, but if you find that you want to perform some tasks for a specific version you can use `requested_version` and `latest_version`. This may be updated in the [near future](https://github.com/bwillis/versioncake/issues/1).

### Client requests

When a client makes a request it will automatically receive the latest supported version of the view. The client can also request for a specific version by one of the strategies configured by ``view_version_extraction_strategy``.

# Related Material

## Libraries

- https://github.com/bploetz/versionist
- https://github.com/filtersquad/rocket_pants

## Discussions

- [Steve Klabnik on how to version in a resful way](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned)
- [Rails API project disucssion on versioning](https://github.com/spastorino/rails-api/issues/8)

# Questions?

Create a bug/enhancement/question on github or contact [aantix](https://github.com/aantix) or [bwillis](https://github.com/bwillis) through github.

# License

Version Cake is released under the MIT license: www.opensource.org/licenses/MIT
