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

  s.required_ruby_version = '>= 1.9.2'

  s.add_dependency('actionpack',    '~> 5.0')
  s.add_dependency('activesupport', '~> 5.0')
  s.add_dependency('railties',      '~> 5.0')
  s.add_dependency('tzinfo',        '~> 1.2')

  s.add_development_dependency 'appraisal', '~> 2.2'
  s.add_development_dependency 'coveralls', '~> 0.8'
  s.add_development_dependency 'rake', '> 12.0'

  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'rspec-rails', '~> 3.6'

end
