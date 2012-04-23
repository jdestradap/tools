require 'rest_client'
require 'json'
require 'open-uri'

# This function return the name of the picture
def get_file_name(url)
  a = Array.new
  a = url.split(/\//)
  return a[-1] 
end

# Create the files given the url and the local name of file. 
def get_file(name,url)
  open(name, 'wb') do |file|
    file << open(url).read
  end
end

# json
url = 'http://api.reddit.com/r/aww.json'
 
response = RestClient.get(url)
 
json_response = response.body

json_response_ruby = JSON.parse json_response

if json_response_ruby.has_key? 'Error'
  raise "web service error"
end

# Here is parsed the json
json_response_ruby['data']['children'].each { |result|

  url = ""
  url =  result['data']['url']
  if url.end_with?(".jpg") || url.end_with?(".gif") 
    name = get_file_name(url)
    get_file(name,url)
  end
}