ENV['RACK_ENV'] = 'test'

require 'test/unit'
require 'rack/test'
require './app'


class AppTest < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		Sinatra::Application
	end

	def test_get_feeds
		get '/feeds'
		assert_equal last_response.status, 200
		json = JSON.parse last_response.body
		assert json.kind_of?(Array)
	end

	def test_add_feed_success
		url = 'http://www.engadget.com/rss.xml'
		post '/feeds', { url: url }.to_json, 'CONTENT_TYPE' => 'application/json'
		assert_equal last_response.status, 200
		json = JSON.parse last_response.body
		assert json.has_key?('id')
		assert_equal 'Engadget RSS Feed', json['title']
		assert_equal url, json['url']
		assert_equal 'Engadget', json['description']
	end

	def test_add_feed_bad_request
		post '/feeds', {}.to_json, 'CONTENT_TYPE' => 'application/json'
		assert_equal last_response.status, 400
		json = JSON.parse last_response.body
		assert_equal 'NO_URL', json['reason']
	end

	def test_add_feed_bad_url
		post '/feeds', { url: 'http://bad' }.to_json, 'CONTENT_TYPE' => 'application/json'
		assert_equal last_response.status, 400
		json = JSON.parse last_response.body
		assert_equal 'BROKEN_URL', json['reason']
	end
end