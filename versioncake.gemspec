# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "versioncake/version"

Gem::Specification.new do |s|
  s.name        = "versioncake"
  s.version     = VersionCake::VERSION
  s.license     = 'MIT'
  s.authors     = ["Jim Jones", "Ben Willis"]
  s.email       = ["jim.jones1@gmail.com", "benjamin.willis@gmail.com"]
  s.homepage    = "http://bwillis.github.io/versioncake"
  s.summary     = %q{Easily render versions of your rails views.}
  s.description = %q{Render versioned views automagically based on the clients requested version.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('actionpack',    '>= 3.2')
  s.add_dependency('activesupport', '>= 3.2')
  s.add_dependency('railties',      '>= 3.2')
  s.add_dependency('tzinfo')

  s.add_development_dependency 'test-unit'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'rake'

end
