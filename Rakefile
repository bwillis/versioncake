require 'bundler/gem_tasks'

require 'rake/dsl_definition'
require 'bundler'
Bundler.setup

require 'rspec/core/rake_task'
require 'appraisal'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec)

task default: :spec