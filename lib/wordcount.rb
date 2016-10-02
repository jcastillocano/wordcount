# frozen_string_literal: true
require 'sinatra/base'
require 'sinatra/activerecord'
require 'webrick'
require 'webrick/https'

# Word Count App, provides Counter (logic) and WordCount (endpoints)
module WordCountApp
  MAX_SIZE = 10_240_000

  # Global results and word counter
  class Counter #:nodoc:
    def initialize
      @files = {}
    end

    def count(filename, text, reg_skip = nil)
      output = { 'total' => 0, 'words' => {} }
      words_array = text.scan(/[[:alpha:]]+/)
      words_array.each do |w|
        next if !reg_skip.nil? && w.include?(reg_skip)
        output['words'][w] = output['words'].key?(w) ? output['words'][w] + 1 : 1
        output['total'] += 1
      end

      # Update general stats
      @files[filename] = output.to_json
    end

    def parsed(file)
      @files&.key?(file)
    end

    def status(file)
      @files&.key?(file) ? @files[file] : "{\"error\": \"File #{file} not found\"}"
    end
  end

  # REST API endpoint for word counter
  class WordCount < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    def initialize(app = nil, _params = {})
      super(app)
      @word = Counter.new
    end

    def valid_file(file)
      halt 200, '{"error": "File size greater than 10MB"}' if file[:tempfile].size > MAX_SIZE
      [file[:filename], file[:tempfile].read]
    end

    def valid_file_params(params)
      unless params[:file] && params[:file][:tempfile] && params[:file][:filename]
        halt 200, '{"error": "No file supplied"}'
      end
      halt 200, '{"error": "File already parsed"}' if @word.parsed(params[:file][:filename])
    end

    def valid_skip_regex(params)
      unless params[:skip]&.match(/^[[:alpha:]]+$/)
        halt 200, '{"error": "Invalid skip regex"}'
      end
      params[:skip]
    end

    post '/api/v1/upload' do
      valid_file_params params
      name, text = valid_file(params[:file])
      @word.count(name, text)
    end

    post '/api/v1/upload/:skip' do
      valid_file_params params
      skip_match = valid_skip_regex params
      name, text = valid_file(params[:file])
      @word.count(name, text, skip_match)
    end

    get '/api/v1/status/:file' do
      @word.status params[:file]
    end
  end
end
