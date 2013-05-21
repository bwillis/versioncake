require 'bundler/gem_tasks'

require 'rake/dsl_definition'
require 'bundler'
Bundler.setup

require 'rake/testtask'
require 'appraisal'

Bundler::GemHelper.install_tasks

task :default => :test

Rake::TestTask.new do |i|
  i.libs << 'test'
  i.test_files = FileList['test/**/*_test.rb']
  i.verbose = true
end