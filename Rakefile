spec_root = File.dirname(__FILE__) + '/spec'

require "#{spec_root}/rails_root/config/boot"

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'
require 'spec/rake/spectask'

spec_prereq = File.exist?(File.join(RAILS_ROOT, 'config', 'database.yml')) ? "db:test:prepare" : :noop
task :noop do
end

task :default => :spec
task :stats => "spec:statsetup"

desc "Run all specs in spec directory (excluding plugin specs)"
Spec::Rake::SpecTask.new(:spec => spec_prereq) do |t|
  t.spec_opts = ['--options', "\"#{spec_root}/spec.opts\""]
  t.spec_files = FileList['spec/**/*_spec.rb']
end

namespace :spec do
  desc "Run all specs in spec directory with RCov (excluding plugin specs)"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_opts = ['--options', "\"#{spec_root}/spec.opts\""]
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.rcov = true
    t.rcov_opts = lambda do
      IO.readlines("#{spec_root}/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end
end

# Generate the RDoc documentation
Rake::RDocTask.new { |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = "HasEnum -- Enumerations for ActiveRecord"
  rdoc.options << '--line-numbers' << '--inline-source' << '-A cattr_accessor=object'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
}
