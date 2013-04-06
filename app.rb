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
	puts 'feeds list'
	@feeds = Feed.order("created_at DESC")
	@feed = Feed.new
	haml :"feeds/list", layout: false
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
		return "RSS source is broken... Please check your RSS source and see if it's still available."
	end

	@rss = RSS::Parser.parse(rss_content, false)

	haml :"feeds/show"
end

not_found do
	"This is not found~~"
end