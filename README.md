WordCount
=========

Basic word count REST API. It counts all words (and its occurrences) over an ASCII file, skipping those that match with regex (if given).

#### Notes

1.	If a file has been already parsed, it will raise an error.
2.	If a file is greater than 10MB it will be rejected by the server.
3.	A word is a chain of alpha characteres [a-zA-Z]. That excludes:
	-	Numbers
	-	Any symbol (,.?= etc)
	-	Whitespaces (\b\t\n etc)
4.	Any symbol, space or number in the middle of a word will split that word in two: e.g. trave-lling will be parsed as 'trave' and 'lling'
5.	Only alpha characteres can be especified as skip regex, anything else will be rejected
6.	WordCount is case-sensitive: Hello and hello are two different words

API Endpoints
-------------

#### V1

-	/api/v1/upload

	-	Description: upload an ASCII file, parse it, and return total words plus list of words with occurrences
	-	Method: POST
	-	Arguments:
		-	file: text ASCII file, less than 10MB
	-	Output: JSON {total (int), words (hash str:int)}

-	/api/v1/upload/:skip

	-	Description: upload an ASCII file, parse it, and return total words plus list of words with occurrences excluding words that contain skip string
	-	Method: POST
	-	Arguments:
		-	file: text ASCII file, less than 10MB
	-	Output: JSON {total (int), words (hash str:int)}

-	/api/v1/status/:file

	-	Description: query if a file has been already parsed, if yes return its saved result.
	-	Method: GET
	-	Output: JSON {total (int), words (hash str:int)}

Error management: JSON {error (str)}

Config
------

List of environment variables: * *RACK_ENV*: execution environment (default: test) * *WC_HOST*: webrick host ip (default: 0.0.0.0) * *WC_PORT*: webrick port number (default: 8888)

Dependencies
------------

-	Ruby 2.3.1
-	RVM 1.26.11

To install dependencies:

```
gem install bundler
bundle install
```

Usage
-----

To start a new server:

`bundle exec rake run`

A new Webrick Server will start to listen on *WC_HOST*:*WC_PORT*

Development
-----------

By default, running `bundle exec rake` you will trigger:

-	[Rubocop](https://github.com/bbatsov/rubocop): static code analyzer
-	[Rspec](http://rspec.info/): Unit tests
-	[Rubycritic](https://github.com/whitesmith/rubycritic): code quality reporter

To run *rubocop*: `bundle exec rake rubocop`

To run *rspec*: `bundle exec rake test`

To run *rubycritic*: `bundle exec rake rubycritic`

Contributors
------------

*WordCount* initial author was [Juan Carlos Castillo Cano](https://github.com/jcastillocano)
