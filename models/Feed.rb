require 'mongo_mapper'

class Feed
	include MongoMapper::Document

	key :url,			String
	key :title,			String
	key :description,	String

	timestamps!
end