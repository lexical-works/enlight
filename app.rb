require 'sinatra'
require 'sinatra/mongomapper'
require 'sinatra/reloader' if (development? && !defined? $_rakefile)
require 'haml'
require 'rss'
require 'json'
require 'open-uri'
require 'mongo_mapper'

require './models/Feed'


configure :development do
	set :mongomapper, 'mongomapper://root:Adventure41@widmore.mongohq.com:10010/enlight-development'
end

configure :test do
	set :mongomapper, 'mongomapper://root:Adventure41@widmore.mongohq.com:10000/enlight-test'
end


# Completed.
get '/feeds' do
	feeds = Feed.sort :created_at.desc
	status 200
	feeds.to_json
end


# Completed.
get '/feeds/:id' do |id|
	feed = Feed.find id
	if feed then
		status 200
		feed.to_json
	else
		status 404
	end
end


# TODO with no tests.
put '/feeds/:id' do |id|
	feed = Feed.find id
	feed.url = params[:url]
	feed.save
	feed.to_json
end


# Completed.
post '/feeds' do
	data = JSON.parse request.body.read.to_s
	if data.has_key?('url') == false then
		status 400
		return { reason: 'NO_URL' }.to_json
	end

	begin
		open(data['url']) do |f|
			rss_content = f.read
			rss = RSS::Parser.parse(rss_content, false)
			
			feed = Feed.new
			feed.title = rss.channel.title
			feed.url = data['url']
			feed.description = rss.channel.description
			feed.save

			feed.to_json
		end
	rescue Exception => e
		status 400
		{ reason: 'BROKEN_URL' }.to_json
	end
end


# Completed.
delete '/feeds/:id' do |id|
	feed = Feed.find id
	if feed then
		feed.destroy
		status 200
	else
		status 404
	end
end


not_found do
	"This is not found."
end
