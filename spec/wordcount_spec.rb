# frozen_string_literal: true
require 'spec_helper'
require 'json'
require 'wordcount'

describe 'WordCount App - WordCount' do
  include Rack::Test::Methods

  def app
    WordCountApp::WordCount
  end

  describe 'Upload method' do
    it 'Basic upload method verification' do
      post '/api/v1/upload', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/basic_upload_content.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/basic_upload_response.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Upload error: no file supplied' do
      post '/api/v1/upload', 'data' => nil
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/no_file.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Upload error: empty file supplied' do
      post '/api/v1/upload', 'file' => nil
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/empty_file.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Upload error: file has been already parsed' do
      post '/api/v1/upload', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/basic_upload_content.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/parsed_file.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Camel-Case sensitive' do
      post '/api/v1/upload', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/case_sensitive.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/case_sensitive.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Weird symbols' do
      post '/api/v1/upload', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/weird_symbols.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/weird_symbols.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end
  end

  describe 'Upload skip method' do
    it 'Basic upload method verification' do
      post '/api/v1/upload/This', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/basic_upload_content_skip.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/basic_upload_response_skip.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Camel-Case sensitive' do
      post '/api/v1/upload/ex', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/case_sensitive_skip.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/case_sensitive_skip.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Weird symbols' do
      post '/api/v1/upload/is', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/weird_symbols_skip.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/weird_symbols_skip.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Invalid skip regex' do
      post '/api/v1/upload/53', 'file' => Rack::Test::UploadedFile.new('spec/payloads/wordcount/no_numbers_skip.txt', 'text/plain')
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/no_numbers_skip.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end
  end

  describe 'Status method' do
    it 'Valid status file' do
      get '/api/v1/status/basic_upload_content.txt'
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/basic_upload_response.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end

    it 'Invalid status file' do
      get '/api/v1/status/invalid_file.txt'
      upload_response = JSON.parse(IO.read('spec/payloads/wordcount/invalid_status_response.json'))
      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq(upload_response)
    end
  end
end
