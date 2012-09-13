# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "versioncake/version"

Gem::Specification.new do |s|
  s.name        = "versioncake"
  s.version     = VersionCake::VERSION
  s.authors     = ["Jim Jones", "Ben Willis"]
  s.email       = ["jim.jones1@gmail.com", "benjamin.willis@gmail.com"]
  s.homepage    = "https://github.com/bwillis/versioncake"
  s.summary     = %q{Easily render versions of your rails views.}
  s.description = %q{Render versioned views automagically based on the clients requested version.}

  #s.rubyforge_project = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "mocha"
end
