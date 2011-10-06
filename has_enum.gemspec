# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "has_enum/version"

Gem::Specification.new do |s|
  s.name        = "has_enum"
  s.version     = HasEnum::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andreas Korth", "Konstantin Shabanov", "Dmitry Lihachev"]
  s.email       = ["lda@openteam.ru"]
  s.homepage    = "http://github.com/openteam/has_enum"
  s.summary     = %q{Gem for Rails to easily handle enumeration attributes in models}
  s.description = %q{Gem for and Rails3 to easily handle enumeration attributes in ActiveRecord's models}
  s.licenses    = ["MIT"]

  s.add_dependency "rails", ["> 3.0.0"]
  s.add_development_dependency "rspec", ["~> 2.5"]
  s.add_development_dependency "sqlite3", ["~> 1.3.3"]

  s.extra_rdoc_files = [ "LICENSE.txt", "README.md"]
  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths    = ["lib"]
end
