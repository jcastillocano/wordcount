require File.expand_path('wordcount', File.join(File.dirname(__FILE__), 'lib'))

webrick_options = {
  Host: '0.0.0.0',
  Port: 8888,
  Logger: WEBrick::Log.new($stderr, WEBrick::Log::DEBUG),
  DocumentRoot: './root/',
  app: WordCountApp::WordCount
}

Rack::Server.start webrick_options
