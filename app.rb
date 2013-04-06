require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader' if (development? && !defined? $_rakefile)
require 'haml'
require 'rss'
require 'open-uri'

require './models/Feed'

set :database, "sqlite3:///db/enlight.db"

get '/' do
	haml :"index"
end

get '/feeds/list' do
	@feeds = Feed.order("created_at DESC")
	haml :"feeds/list", layout: false
end

post '/feeds/new' do
	begin
		open(params[:feed_url]) do |f|
			rss_content = f.read
			rss = RSS::Parser.parse(rss_content, false)
			
			feed = Feed.new
			feed.title = rss.channel.title
			feed.url = params[:feed_url]
			feed.description = rss.channel.description
			feed.save

			@feeds = Feed.order("created_at DESC")
			haml :"feeds/list", layout: false
		end
	rescue Exception => e
		@error_message = "RSS source is broken... Please check your RSS source and see if it's still available."
		@error_exception = e
		haml :exception
	end
end

get '/feeds/show/:id' do |id|
	feed = Feed.find_by_id(id)
	redirect not_found if !feed

	rss_content = ""
	begin
		open(feed.url) do |f|
			rss_content = f.read
		end
	rescue Exception => e
		@error_message = "RSS source is broken... Please check your RSS source and see if it's still available."
		@error_exception = e
		haml :exception
	end

	@rss = RSS::Parser.parse(rss_content, false)

	haml :"feeds/show"
end

not_found do
	"This is not found~~"
end