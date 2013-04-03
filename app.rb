require 'sinatra'
require "sinatra/activerecord"
require "sinatra/reloader" if development?

get '/' do
	'hello world! 2'
end