require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader' if (development? && !defined? $_rakefile)
require 'haml'

require './models/Feed'

set :database, "sqlite3:///db/enlight.db"

get '/' do
	haml :"index"
end

get '/feeds/list' do
	@feeds = Feed.order("created_at DESC")
	@feed = Feed.new
	haml :"feeds/list"
end