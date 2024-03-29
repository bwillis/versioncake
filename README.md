![Version Cake](https://raw.github.com/alicial/versioncake/master/images/versioncake-logo450x100.png)

![Ruby](https://github.com/bwillis/versioncake/workflows/Ruby/badge.svg?branch=master)
[![Code Climate](https://codeclimate.com/github/bwillis/versioncake.png)](https://codeclimate.com/github/bwillis/versioncake)
[![Coverage Status](https://coveralls.io/repos/bwillis/versioncake/badge.png?branch=master)](https://coveralls.io/r/bwillis/versioncake)
[![Gem Version](https://badge.fury.io/rb/versioncake.png)](http://badge.fury.io/rb/versioncake)

Co-authored by Ben Willis ([bwillis](https://github.com/bwillis/)) and Jim Jones ([aantix](https://github.com/aantix)).

Version Cake is an unobtrusive way to version APIs in your Rails app.

- Easily version any view with their API version:

```ruby
app/views/posts/
 - index.xml.v1.builder
 - index.xml.v3.builder
 - index.json.v1.jbuilder
 - index.json.v4.jbuilder
```
- Gracefully degrade requests to the latest supported version
- Clients can request API versions through different strategies
- Dry your controller logic with exposed helpers

Check out https://github.com/bwillis/350-rest-api-versioning for a comparison of traditional versioning approaches and a versioncake implementation.

## Install

```
gem install versioncake
rails g versioncake:install
```

### Requirements

| Version | Rails 3.2 Support? | Rails 4 Support? | Rails >4.1 Support? | Rails >5 Support? | Rails >5.2 Support? | Rails 6 Support? | Rails 7 Support? | [Rails API](https://github.com/rails-api/rails-api) 0.2 Support? |
| -------:|:---------:| -------:| -------:| -------:| -------:| -------:| -------:| -------:|
| [1.0](CHANGELOG.md#100-march-14-2013) | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| [1.1](CHANGELOG.md#110-may-18-2013)   | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| [1.2](CHANGELOG.md#120-may-26-2013)   | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| [1.3](CHANGELOG.md#130-sept-26-2013)  | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| [>2.0](CHANGELOG.md#200-feb-6-2014)   | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| [>2.4](CHANGELOG.md#200-feb-6-2014)   | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| [>3.0](CHANGELOG.md#300-aug-3-2015)   | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| [>3.3](CHANGELOG.md#330-may-7-2017)   | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ |
| [>4.0](CHANGELOG.md)                  | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| [>4.1](CHANGELOG.md)                  | ❌ | ❌ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |

## Upgrade v2.0 -> v3.0

### Accept header name changes

The default accept header was changed from 'X-API-Version' to 'API-Version'. If you require the 'X-' or some other variant, you can specify a custom strategy as outlined in Extraction Strategy section below.

### Configuration changes

Configuration is now done with an initializer-you can generate a default one with `rails g versioncake:install` and then modify the generated file to match your configuration.

### Configuration changes

The configuration options for Version Cake have changed:

| Old Name                                     | New Name               |
| -------------------------------------------- | ---------------------- |
| config.versioncake.supported_version_numbers | config.resources       |
| config.versioncake.default_version           | config.missing_version |

## Upgrade v1.* -> v2.0

### Filename changes
The major breaking change to require a bump to v2.0 was the order of the extensions. To avoid priority issues with the format (#14), the version number and the format have been swapped.

`index.v1.json.jbuilder` -> `index.json.v1.jbuilder`

To make it easier to upgrade, run the following command to automatically rename these files:

`versioncake migrate` or `versioncake migrate path/to/views`

### Configuration changes

The configuration options for Version Cake have been namespaced and slightly renamed. The following is a mapping of the old names to the new names:

| Old Name | New Name |
| --------------------------------------- | -------------------------------------------- |
| config.view_versions                    | config.versioncake.supported_version_numbers |
| config.view_version_extraction_strategy | config.versioncake.extraction_strategy       |
| config.view_version_string              | config.versioncake.version_key               |
| config.default_version                  | config.versioncake.default_version           |

## Example

In this simple example we will outline the code that is introduced to support a change in a version.

### config/application.rb
```ruby
VersionCake.setup do |config|
  config.resources do |r|
    r.resource %r{.*}, [], [], (1..4)
  end
  config.extraction_strategy = :query_parameter # for simplicity
  config.missing_version = 4
end
```

Often times with APIs, depending upon the version, different logic needs to be applied. With the following controller code, the initial value of @posts includes all Post entries.
But if the requested API version is three or greater, we're going to eagerly load the associated comments as well.

Being able to control the logic based on the api version allow you to ensure forwards and backwards compatibility for future changes.

### PostsController
```ruby
class PostsController < ApplicationController
  def index
    # shared code for all versions
    @posts = Post.scoped

    # version 3 or greated supports embedding post comments
    if request_version >= 3
      @posts = @posts.includes(:comments)
    end
  end
end
```

See the view samples below. The basic top level posts are referenced in views/posts/index.json.v1.jbuilder.
But for views/posts/index.json.v4.jbuilder, we utilize the additional related comments.

### Views

Notice the version numbers are denoted by the "v{version number}" extension within the file name.

#### views/posts/index.json.v1.jbuilder
```ruby
json.array!(@posts) do |post|
    json.(post, :id, :title)
end
```

#### views/posts/index.json.v4.jbuilder
```ruby
json.array!(@posts) do |post|
    json.(post, :id, :title)
    json.comments post.comments, :id, :text
end
```

### Sample Output

When a version is specified for which a view doesn't exist, the request degrades and renders the next lowest version number to ensure the API's backwards compatibility.  In the following case, since views/posts/index.json.v3.jbuilder doesn't exist, views/posts/index.json.v1.jbuilder is rendered instead.

#### http://localhost:3000/posts.json?api_version=3
```javascript
[
  {
    id: 1
    title: "Version Cake v0.1.0 Released!"
    name: "Ben"
    updated_at: "2012-09-17T16:23:45Z"
  },
  {
    id: 2
    title: "Version Cake v0.2.0 Released!"
    name: "Jim"
    updated_at: "2012-09-17T16:23:32Z"
  }
]
```


For a given request, if we specify the version number, and that version of the view exists, that version specific view version will be rendered.  In the below case, views/posts/index.json.v1.jbuilder is rendered.

#### http://localhost:3000/posts.json?api_version=2 or http://localhost:3000/posts.json?api_version=1
```javascript
[
  {
    id: 1
    title: "Version Cake v0.1.0 Released!"
    name: "Ben"
    updated_at: "2012-09-17T16:23:45Z"
  },
  {
    id: 2
    title: "Version Cake v0.2.0 Released!"
    name: "Jim"
    updated_at: "2012-09-17T16:23:32Z"
  }
]
```


When no version is specified, the configured `missing_version` will be used to render a view.  In this case, views/posts/index.json.v4.jbuilder.

#### http://localhost:3000/posts.json
```javascript
[
  {
    id: 1
    title: "Version Cake v0.1.0 Released!"
    name: "Ben"
    updated_at: "2012-09-17T16:23:45Z"
    comments: [
      {
        id: 1
        text: "Woah interesting approach on versioning"
      }
    ]
  },
  {
     id: 2
     title: "Version Cake v0.2.0 Released!"
     name: "Jim"
     updated_at: "2012-09-17T16:23:32Z"
     comments: [
      {
        id: 4
        text: "These new features are greeeeat!"
      }
    ]
  }
]
```

## How to use

### Configuration
The configuration lives in `config/initializers/versioncake.rb`.

#### Versioned Resources
Each individual resource uri can be identified by a regular expression. For each one it can be customized to have obsolete, deprecated, supported versions.

```ruby
  config.resources do |r|
    # r.resource uri_regex, obsolete, deprecated, supported

    # version 2 and 3 are still supported on users resource
    r.resource %r{/users}, [1], [2,3], [4]

    # all other resources only allow v4
    r.resource %r{.*}, [1,2,3], [], [4]
  end
```

#### Extraction Strategy

You can also define the way to extract the version. The `extraction_strategy` allows you to set one of the default strategies or provide a proc to set your own. You can also pass it a prioritized array of the strategies.
```ruby
config.extraction_strategy = :query_parameter # [:http_header, :http_accept_parameter]
```
These are the available strategies:

Strategy | Description | Example
--- | --- | ---
:query_parameter | version in the url query parameter, for testing or to override for special case | `http://localhost:3000/posts.json?api_version=1`  (This is the default.)
:path_parameter | version in the url path parameter | `api/v:api_version/`
:request_parameter | version that is sent in the body of the request | Good for testing.
:http_header | Api version HTTP header | `API-Version: 1`
:http_accept_parameter | HTTP Accept header | `Accept: application/xml; api_version=1` [why do this?](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned)
custom | takes the request object and must return an integer | lambda {&#124;request&#124; request.headers["HTTP_X_MY_VERSION"].to_i } or class ExtractorStrategy; def execute(request);end;end

If you use the path_parameter strategy with resources routes, you will want to setup your routes.rb config file to capture the api version.  You can do that in a few ways.  If you have just a few api routes you might specify the path directly like this:
```
resources :cakes, path: '/api/v:api_version/cakes'
```
If you are using a lot of routes it might be better to keep them all inside a scope like this:
```
scope '/api/v:api_version' do
  resources :cakes
end
```

#### Default Version

When no version is supplied by a client, the version rendered will be the latest version by default. If you want to override this to another version, set the following property:
```ruby
config.missing_version = 4
```

#### Version String

The extraction strategies use a default string key of `api_version`, but that can be changed:
```ruby
config.version_key = "special_version_parameter_name"
```

#### Version String
If you do not wish to use the magic mapping of the version number to templates it can be disabled:
```ruby
config.rails_view_versioning = false
```

#### Response Version

If a client requests a specific version (or does not) and a version applies to the resource you can configure it to be in the response. Use the following configuration:
```ruby
config.response_strategy = [:http_content_type, :http_header]
```

### Version your views

When a client makes a request to your controller the latest version of the view will be rendered. The latest version is determined by naming the template or partial with a version number that you configured to support.

```
- app/views/posts
    - index.html.erb
    - edit.html.erb
    - show.html.erb
    - show.json.jbuilder
    - show.json.v1.jbuilder
    - show.json.v2.jbuilder
    - new.html.erb
    - _form.html.erb
```

If you start supporting a newer version, v3 for instance, you do not have to copy posts/show.v2 to posts/show.v3. By default, the request for v3 or higher will gracefully degrade to the view that is the newest, supported version, in this case posts/show.v2.

### Controller

You don't need to do anything special in your controller, but if you find that you want to perform some tasks for a specific version you can use `request_version` and `version_context.resource.latest_version`. This may be updated in the [near future](https://github.com/bwillis/versioncake/issues/1).
```ruby
def index
  # shared code for all versions
  @posts = Post.scoped

  # version 3 or greated supports embedding post comments
  if request_version >= 3
    @posts = @posts.includes(:comments)
  end
end
```
### Client requests

When a client makes a request it will automatically receive the latest supported version of the view. The client can also request for a specific version by one of the strategies configured by ``view_version_extraction_strategy``.

### Raised exceptions

These are the types of exceptions VersionCake will raise:

|Exception type|Description|
|--------------|-----------|
|VersionCake::UnsupportedVersionError| The version is invalid, too high or too low for the resource.|
|VersionCake::ObsoleteVersionError|The version is obsolete for the resource.|
|VersionCake::MissingVersionError|If no `config.missing_version` is specified, this will be raised when no version is in the request.|

### Handling Exceptions

Handling exceptions can simply be done by using Rails `rescue_from` to return app specific messages to the client.

```ruby
class ApplicationController < ActionController::Base

  ...

  rescue_from VersionCake::UnsupportedVersionError, :with => :render_unsupported_version

  private

  def render_unsupported_version
    headers['API-Version-Supported'] = 'false'
    respond_to do |format|
      format.json { render json: {message: "You requested an unsupported version (#{request_version})"}, status: :unprocessable_entity }
    end
  end

  ...

end

```

## How to test

Testing can be painful but here are some easy ways to test different versions of your api using version cake.

### Test configuration

Allowing more extraction strategies during testing can be helpful when needing to override the version.
```ruby
# config/environments/test.rb
config.extraction_strategy = [:query_parameter, :request_parameter, :http_header, :http_accept_parameter]
```

### Testing a specific version

One way to test a specific version for would be to stub the requested version in the before block:
```ruby
before do
  @controller.stubs(:request_version).returns(3)
end
```

You can also test a specific version through a specific strategy such query_parameter or request_parameter strategies (configured in test environment) like so:
```ruby
# test/integration/renders_integration_test.rb#L47
test "render version 1 of the partial based on the parameter _api_version" do
  get renders_path("api_version" => "1")
  assert_equal "index.html.v1.erb", @response.body
end
```

### Testing all supported versions

You can iterate over all of the supported version numbers by accessing the ```VersionCake.config.versioned_resources.first.available_versions```.

```ruby
VersionCake.config.versioned_resources.first.available_versions.each do |supported_version|
  before do
    @controller.stubs(:request_version).returns(supported_version)
  end

  test "all versions render the correct template" do
    get :index
    assert_equal @response.body, "index.html.v1.erb"
  end
end
```

# Thanks!

Thanks to all those who have helped make Version Cake really sweet:

* [Alicia](https://github.com/alicial)
* [Rohit](https://github.com/rg)
* [Sevag](https://github.com/sevagf)
* [Billy](https://github.com/bcatherall)
* [Jérémie Meyer de Ville](https://github.com/jeremiemv)
* [Michael Elfassy](https://github.com/elfassy)
* [Kelley Reynolds](https://github.com/kreynolds)
* [Washington L Braga Jr](https://github.com/huoxito)
* mbradshawabs
* [Richard Nuno](https://github.com/richardnuno)
* [Andres Camacho](https://github.com/andresfcamacho)
* [Yukio Mizuta](https://github.com/untidy-hair)
* [David Butler](https://github.com/dwbutler)
* Jeroen K.
* [Masaya Myojin](https://github.com/mmyoji)
* [John Hawthorn](https://github.com/jhawthorn)
* Ersin Akinci
* [Bartosz Bonisławski](https://github.com/bbonislawski)
* [Harry Lascelles](https://github.com/hlascelles)
* [James Carscadden](https://github.com/JamesCarscadden)

# Related Material

## Libraries

- https://github.com/bploetz/versionist
- https://github.com/filtersquad/rocket_pants
- https://github.com/lyonrb/biceps

## Discussions

- [Peter Williams on versioning rest web services](http://barelyenough.org/blog/2008/05/versioning-rest-web-services/)
- [Steve Klabnik on how to version in a resful way](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned)
- [Rails API project disucssion on versioning](https://github.com/rails-api/rails-api/issues/8)
- [Railscast on versioning](http://railscasts.com/episodes/350-rest-api-versioning)
- [Rails core discussion](https://groups.google.com/forum/#!msg/rubyonrails-core/odwmEYYIum0/9POep66BvoMJ)
- [RubyWeekly](http://rubyweekly.com/archive/119.html)
- [API building tools on Ruby Toolbox](https://www.ruby-toolbox.com/categories/API_Builders)

# Security issues?

If you think you have a security vulnerability, please submit the issue and the details to [https://hackerone.com/versioncake](https://hackerone.com/versioncake)

# Questions?

Create a bug/enhancement/question on github or contact [aantix](https://github.com/aantix) or [bwillis](https://github.com/bwillis) through github.

# License

Version Cake is released under the MIT license: www.opensource.org/licenses/MIT
