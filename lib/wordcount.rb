# frozen_string_literal: true
require 'sinatra/base'
require 'sinatra/activerecord'
require 'webrick'
require 'webrick/https'

# Word Count App, provides Counter (logic) and WordCount (endpoints)
module WordCountApp
  MAX_SIZE = 10_240_000
  PATH_DOES_NOT_EXIST = '{"error": "Path does not exist"}'
  FILE_SIZE_ERROR = '{"error": "File size greater than 10MB"}'
  NO_FILE_SUPPLIED = '{"error": "No file supplied"}'
  FILE_ALREADY_PARSED = '{"error": "File already parsed"}'
  INVALID_SKIP_REGEX = '{"error": "Invalid skip regex"}'

  # Global results and word counter
  class Counter
    def initialize
      # General stats, keep records of every file parsed
      @files = {}
    end

    def already_parsed(file)
      @files&.key?(file)
    end

    def status(file)
      @files[file] || "{\"error\": \"File #{file} not found\"}"
    end

    def count(filename, text, reg_skip = nil)
      output = { 'total' => 0, 'words' => {} }
      words_array = text.scan(/[[:alpha:]]+/)
      words_array.each do |w|
        next if !reg_skip.nil? && w.include?(reg_skip)
        output['words'].tap { |ws| ws[w] = ws.key?(w) ? ws[w] + 1 : 1 }
        output['total'] += 1
      end

      # Update general stats
      @files[filename] = output.to_json
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
      halt 200, FILE_SIZE_ERROR if File.size(file[:tempfile]) > MAX_SIZE
      [file[:filename], file[:tempfile].read]
    end

    def valid_file_params(params)
      params[:file] && params[:file][:tempfile] && params[:file][:filename] || halt(200, NO_FILE_SUPPLIED)
      !@word.already_parsed(params[:file][:filename]) || halt(200, FILE_ALREADY_PARSED)
    end

    def valid_skip_regex(params)
      halt 200, INVALID_SKIP_REGEX unless params[:skip]&.match(/^[[:alpha:]]+$/)
      params[:skip]
    end

    post '/api/v1/upload' do
      valid_file_params params
      @word.count(*valid_file(params[:file]))
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

    get '/*' do
      halt 200, PATH_DOES_NOT_EXIST
    end

    post '/*' do
      halt 200, PATH_DOES_NOT_EXIST
    end
  end
end
