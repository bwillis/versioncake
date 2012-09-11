require "bundler/gem_tasks"

require 'rake/dsl_definition'
require "bundler"
Bundler.setup

require "rspec"
require "rspec/core/rake_task"
require 'rake/testtask'

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Bundler::GemHelper.install_tasks

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

Rake::TestTask.new do |i|
  #i.test_files = FileList['test/test_*.rb']
  i.test_files = FileList.new('test/**/*.rb')
  i.verbose = true
end