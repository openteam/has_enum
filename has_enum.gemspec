# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{has_enum}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dmitri Lihachev"]
  s.date = %q{2010-12-06}
  s.description = %q{has_enum weee}
  s.email = %q{lda@openteam.ru}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "has_enum.gemspec",
    "lib/has_enum.rb",
    "lib/has_enum/active_record.rb",
    "lib/has_enum/helpers.rb",
    "spec/has_enum_spec.rb",
    "spec/helpers/form_helper_spec.rb",
    "spec/rcov.opts",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/test_model.rb"
  ]
  s.homepage = %q{https://github.com/etehtsea/has_enum}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{has_enum}
  s.test_files = [
    "spec/has_enum_spec.rb",
    "spec/helpers/form_helper_spec.rb",
    "spec/spec_helper.rb",
    "spec/test_model.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_runtime_dependency(%q<sqlite3-ruby>, ["~> 1.3.2"])
      s.add_development_dependency(%q<rspec>, ["~> 2.2.0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, ["> 3.0.0"])
      s.add_development_dependency(%q<rspec>, ["> 2.2.0"])
      s.add_development_dependency(%q<rails>, ["> 3.0.0"])
      s.add_development_dependency(%q<sqlite3-ruby>, ["> 1.3.2"])
    else
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<sqlite3-ruby>, ["~> 1.3.2"])
      s.add_dependency(%q<rspec>, ["~> 2.2.0"])
      s.add_dependency(%q<rails>, ["~> 3.0.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rails>, ["> 3.0.0"])
      s.add_dependency(%q<rspec>, ["> 2.2.0"])
      s.add_dependency(%q<rails>, ["> 3.0.0"])
      s.add_dependency(%q<sqlite3-ruby>, ["> 1.3.2"])
    end
  else
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<sqlite3-ruby>, ["~> 1.3.2"])
    s.add_dependency(%q<rspec>, ["~> 2.2.0"])
    s.add_dependency(%q<rails>, ["~> 3.0.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rails>, ["> 3.0.0"])
    s.add_dependency(%q<rspec>, ["> 2.2.0"])
    s.add_dependency(%q<rails>, ["> 3.0.0"])
    s.add_dependency(%q<sqlite3-ruby>, ["> 1.3.2"])
  end
end

