require 'sinatra/base'
require 'sinatra/activerecord'

module WordCountApp
  class WordCount < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    post '/upload' do 
    end

    get '/status' do
    end
  end
end
