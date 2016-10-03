# frozen_string_literal: true
ENV['RACK_ENV'] ||= 'test'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'sinatra/activerecord/rake'
require 'rubycritic/rake_task'

require File.expand_path('wordcount', File.join(File.dirname(__FILE__), 'lib'))

desc 'Run rubocop'
task :rubocop do
  RuboCop::RakeTask.new
end

RSpec::Core::RakeTask.new(:test) do |rspec|
  ENV['CONFIG_FILE'] = File.absolute_path(File.join(File.dirname(__FILE__), 'config', 'test_config.yml'))
  rspec.rspec_opts = '--color  --format documentation --format html --out spec/reports/rspec_results.html'\
    ' --format RspecJunitFormatter --out spec/reports/rspec_results.xml'
end

task :rubycritic do
  RubyCritic::RakeTask.new do |task|
    task.options = '--no-browser'
  end
end

task :run do
  webrick_options = {
    Host: ENV['WC_HOST'] || '0.0.0.0',
    Port: ENV['WC_PORT'] || 8888,
    Logger: WEBrick::Log.new($stderr, WEBrick::Log::DEBUG),
    DocumentRoot: './root/',
    app: WordCountApp::WordCount
  }

  Rack::Server.start webrick_options
end

task default: [:rubocop, :rubycritic, :test]
