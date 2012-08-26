# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "renderversion/version"

Gem::Specification.new do |s|
  s.name        = "renderversion"
  s.version     = RenderVersion::VERSION
  s.authors     = ["Ben Willis"]
  s.email       = ["benjamin.willis@gmail.com"]
  s.homepage    = "https://github.com/bwillis/renderversion"
  s.summary     = %q{Easily render version of your rails views.}
  s.description = %q{Render versioned views automagically based on the clients requested version in the header.}

  #s.rubyforge_project = ""

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "mocha"
end
