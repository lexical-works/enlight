
require 'bundler'
Bundler.require

require 'sass/plugin/rack'

Sass::Plugin.options[:style] = :compressed
Sass::Plugin.options[:template_location] = 'public/stylesheets/sass'
Sass::Plugin.options[:css_location] = 'public/stylesheets'
use Sass::Plugin::Rack

require 'rack/coffee'
use Rack::Coffee, {
		#root: 'public',
	 	urls: '/javascripts/',
	 	output_path: '/public/javascripts'
	}

require "./app"
run Sinatra::Application