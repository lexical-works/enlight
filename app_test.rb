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

	def test_get_feed_success
		url = 'http://www.engadget.com/rss.xml'
		post '/feeds', { url: url }.to_json, 'CONTENT_TYPE' => 'application/json'
		assert_equal last_response.status, 200
		json = JSON.parse last_response.body
		assert json.has_key?('id')

		id = json['id']
		get "/feeds/#{id}"
		json = JSON.parse last_response.body
		assert json.has_key?('id')
		assert_equal 'Engadget RSS Feed', json['title']
		assert_equal url, json['url']
		assert_equal 'Engadget', json['description']
	end

	def test_get_feed_bad_id
		get "/feeds/123"
		assert_equal last_response.status, 404
	end

	def test_put_feed_success
		url0 = 'http://www.engadget.com/rss.xml'
		url1 = 'http://songshuhui.net/feed'

		feed = Feed.first
		id = feed.id
		url = feed.url == url0 ? url1 : url0

		put "/feeds/#{id}", :url => url
		json = JSON.parse last_response.body
		assert_equal 200, last_response.status
		assert_equal url, json['url']
	end

	def test_put_feed_bad_id
		id = 250
		put "/feeds/#{id}", :url => "http://www.google.com"
		assert_equal last_response.status, 404
	end

	def test_put_feed_missing_parameter
		feed = Feed.first
		id = feed.id
		url = feed.url
		
		put "/feeds/#{id}"
		json = JSON.parse last_response.body
		assert_equal last_response.status, 400
		assert_equal 'MISSING_PARAMETER', json['reason']
	end

	def test_put_feed_broken_url
		feed = Feed.first
		id = feed.id

		put "/feeds/#{id}", :url => "http://www.google.com"
		json = JSON.parse last_response.body
		assert_equal 400, last_response.status
		assert_equal 'BROKEN_URL', json['reason']
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

	def test_delete_feed_success
		url = 'http://www.engadget.com/rss.xml'
		post '/feeds', { url: url }.to_json, 'CONTENT_TYPE' => 'application/json'
		assert_equal last_response.status, 200
		json = JSON.parse last_response.body
		assert json.has_key?('id')

		id = json['id']
		delete "/feeds/#{id}"
		assert_equal last_response.status, 200
	end

	def test_delete_feed_bad_id
		delete '/feeds/123'
		assert_equal last_response.status, 404
	end
end