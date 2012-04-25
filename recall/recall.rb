require 'sinatra'  
require 'data_mapper'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/recall.db") 

class ImageUrl
  include DataMapper::Resource
  property :id, Serial
  property :url, Text, :required => true
  property :description, Text
end

DataMapper.finalize.auto_upgrade!