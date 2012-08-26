require "bundler/gem_tasks"

require "bundler"
Bundler.setup

require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

Bundler::GemHelper.install_tasks

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end
