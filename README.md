![Version Cake](https://raw.github.com/alicial/versioncake/master/images/versioncake-logo450x100.png)

[![Build Status](https://secure.travis-ci.org/bwillis/versioncake.png?branch=master)](http://travis-ci.org/bwillis/versioncake)

Co-authored by Ben Willis ([@bwillis](https://github.com/bwillis/)) and Jim Jones ([@aantix](https://github.com/aantix)).

Version Cake is an unobtrusive way to version APIs in your Rails app. 

- Easily version any view with their API version:

```ruby
app/views/posts/
 - index.v1.xml.builder
 - index.v3.xml.builder
 - index.v1.json.jbuilder
 - index.v4.json.jbuilder
```
- Gracefully degrade requests to the latest supported version
- Clients can request API versions through different strategies
- Dry your controller logic with exposed helpers

Check out https://github.com/bwillis/350-rest-api-versioning for a comparison of traditional versioning approaches and a versioncake implementation.

## Install

```
gem install versioncake
```

## Example

In this simple example we will outline the code that is introduced to support a change in a version.

### config/application.rb
```ruby
config.view_versions = (1...4)
config.view_version_extraction_strategy = :http_parameter # for simplicity
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
    if derived_version >= 3
      @posts = @posts.includes(:comments)
    end
  end
end
```

See the view samples below. The basic top level posts are referenced in views/posts/index.v1.json.jbuilder.
But for views/posts/index.v4.json.jbuilder, we utilize the additional related comments.

### Views

Notice the version numbers are denoted by the "v{version number}" extension within the file name.

#### views/posts/index.v1.json.jbuilder
```ruby
json.array!(@posts) do |json, post|
    json.(post, :id, :title)
end
```

#### views/posts/index.v4.json.jbuilder
```ruby
json.array!(@posts) do |json, post|
    json.(post, :id, :title)
    json.comments post.comments, :id, :text
end
```

### Sample Output

When a version is specified for which a view doesn't exist, the request degrades and renders the next lowest version number to ensure the API's backwards compatibility.  In the following case, since views/posts/index.v3.json.jbuilder doesn't exist, views/posts/index.v1.json.jbuilder is rendered instead.

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


For a given request, if we specify the version number, and that version of the view exists, that version specific view version will be rendered.  In the below case, views/posts/index.v1.json.jbuilder is rendered.

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


When no version is specified, the latest version of the view is rendered.  In this case, views/posts/index.v4.json.jbuilder.

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

You need to define the supported versions in your Rails application.rb file as `view_versions`. Use this config to set the range of supported API versions that can be served:

```ruby
config.view_versions = [1,3,4,5] # or (1...5)
```
You can also define the way to extract the version. The `view_version_extraction_strategy` allows you to set one of the default strategies or provide a proc to set your own. You can also pass it a prioritized array of the strategies.
```ruby
config.view_version_extraction_strategy = :query_parameter # [:http_header, :http_accept_parameter]
```
These are the available strategies:
 - **query_parameter**: version in the url query parameter, for testing or to override for special case i.e. ```http://localhost:3000/posts.json?api_version=1```  (This is the default.)
 - **http_header**: Api version HTTP header ie. ```X-API-Version: 1```
 - **http_accept_parameter**: HTTP Accept header ie. ```Accept: application/xml; version=1``` [why do this?](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned)
 - **custom**: `lambda {|request| request.headers["HTTP_X_MY_VERSION"].to_i }` takes the request object and must return an integer

The strategies use a default string of `api_version`, but that can be changed:
```ruby
config.view_version_string = "special_version_parameter_name"
```

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

If you start supporting a newer version, v3 for instance, you do not have to copy posts/show.v2 to posts/show.v3. By default, the request for v3 or higher will gracefully degrade to the view that is the newest, supported version, in this case posts/show.v2.

### Controller

You don't need to do anything special in your controller, but if you find that you want to perform some tasks for a specific version you can use `requested_version` and `latest_version`. This may be updated in the [near future](https://github.com/bwillis/versioncake/issues/1).
```ruby
def index
  # shared code for all versions
  @posts = Post.scoped

  # version 3 or greated supports embedding post comments
  if derived_version >= 3
    @posts = @posts.includes(:comments)
  end
end
```
### Client requests

When a client makes a request it will automatically receive the latest supported version of the view. The client can also request for a specific version by one of the strategies configured by ``view_version_extraction_strategy``.

# Related Material

## Libraries

- https://github.com/bploetz/versionist
- https://github.com/filtersquad/rocket_pants
- https://github.com/lyonrb/biceps

## Discussions

- [Steve Klabnik on how to version in a resful way](http://blog.steveklabnik.com/posts/2011-07-03-nobody-understands-rest-or-http#i_want_my_api_to_be_versioned)
- [Rails API project disucssion on versioning](https://github.com/spastorino/rails-api/issues/8)
- [Railscast on versioning](http://railscasts.com/episodes/350-rest-api-versioning)
- [Ruby5 on versioncake](http://ruby5.envylabs.com/episodes/310-episode-306-september-18th-2012/stories/2704-version-cake)
- [Rails core discussion](https://groups.google.com/forum/#!msg/rubyonrails-core/odwmEYYIum0/9POep66BvoMJ)

# Questions?

Create a bug/enhancement/question on github or contact [aantix](https://github.com/aantix) or [bwillis](https://github.com/bwillis) through github.

# License

Version Cake is released under the MIT license: www.opensource.org/licenses/MIT
