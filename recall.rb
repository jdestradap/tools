# require 'sinatra'  
require 'data_mapper'
# require 'gettingstarted_3.rb'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db") 

class ImageUrl
  include DataMapper::Resource
  property :id, Serial
  property :url, Text, :required => true
  property :url_name, Text
  property :description, Text
end

DataMapper.finalize.auto_upgrade!


# scrapper = Scrapper.new('http://api.reddit.com/r/aww.json')
# scrapper.run


