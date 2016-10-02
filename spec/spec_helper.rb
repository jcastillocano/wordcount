# frozen_string_literal: true
ENV['RACK_ENV'] = 'test'
require 'simplecov'
require 'simplecov-cobertura'
SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::CoberturaFormatter
]
SimpleCov.start

require 'rspec'
require 'rack/test'
require_relative '../lib/wordcount'

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
