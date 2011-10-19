# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "barback/version"

Gem::Specification.new do |s|
  s.name        = "barback"
  s.version     = Barback::VERSION
  s.authors     = ["Richard Allaway"]
  s.email       = ["richard.allaway@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Creates proxy instances of ActiveRecord and ActiveResource models, based on the json representation of a new instance, which will generate handlebars templates for client-side rendering}
  s.description = %q{Generate handlebars templates from Haml or ERB}

  s.rubyforge_project = "barback"

  s.add_dependency("rails", ">= 3.0")

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
