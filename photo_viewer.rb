require 'sinatra'
require './recall.rb'

get '/form' do  
  @picture_urls = ImageUrl.all :order => :id.desc
  erb :form
end  

# get '/' do  
#   @notes = Note.all :.order => :id.desc  
#   @title = 'All Notes'  
#   erb :home  
# end  

# def get_url_picture
# 	i = ImageUrl.all? { |e|  }	
# end