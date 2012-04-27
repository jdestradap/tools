require 'rest_client'
require 'json'
require 'open-uri'
require 'nokogiri'
require './recall.rb'

class ImageNotFound < Exception; end
class ServiseNotSupported < Exception; end

class Scrapper
  def initialize(url)
    @url = url
  end

  # This function returns the name of the picture
  def get_file_name(url)
    a = url.split(/\//)
    return a[-1] 
  end

  # Create the files given the url and the local name of file. 
  def get_file(name,url)
    open(name, 'wb') do |file|
      file << open(url).read
    end
  end

  def get_url(url)

    response = RestClient.get(url)
    # Rescue check the book in order 
    response.body
  end

  def parse_json(json_response)
    json_response_ruby = JSON.parse json_response
    # raise "web service error" if json_response_ruby.has_key? 'Error'
    if json_response_ruby.has_key? 'Error'
      raise "web service error"
    end
    json_response_ruby
  end

  def run
    # json
    data = get_url(@url)

    json_response_ruby = parse_json(data)
    # Here is parsed the json
    
    json_response_ruby['data']['children'].each { |result|

      url = result['data']['url']
      begin
        if url.match(/\.jpg/) || url.match(/\.gif/) 
          image_url = url
          # puts "#{image_url}"
        elsif url.match /imgur/
        # else
          img = ImageGur.new(url)
          image_url = img.get_image_url
        else 
          raise ServiseNotSupported.new("Unsupported image hosting")
        end
      puts image_url

      add_to_database(image_url)

      rescue ImageNotFound => e
        p '==========='
        p e.message
      rescue ServiseNotSupported => e
        p '!!!!!!!!!!!'
        p e.message
        p e.backtrace
      end
    }
  end

  def add_to_database(url)
    url_name = get_file_name(url)
    i = ImageUrl.new  
    i.url = url
    i.url_name = url_name
    i.save 
  # property :id, Serial
  # property :url, Text, :required => true
  # property :url, Text
  # property :description, Text
  end

  # def add_to_database(url)
  #   name = get_file_name(url)
  #   get_file(name,url)

  # end
end

class ImageGur
  def initialize(url)
    @url = url
  end

  def get_image_url
    html = get_html(@url)
    url = parse_html(html)

    # puts url
    
    # open url
    # scrape image tag
    # return url
    
    url
  end

  def get_html(url)
    open(url)
  end

  def parse_html(html)
    doc = Nokogiri::HTML(html)
    nokogiri_img = doc.css('.image.textbox img').first
    raise ImageNotFound.new("No image found in imgur") unless nokogiri_img
    # return url of image
    nokogiri_img['src']
  end
end


scrapper = Scrapper.new('http://api.reddit.com/r/aww.json')
scrapper.run
# doc = open('http://www.google.com/search?q=tenderlove')
# use the nokogiri css 

# $('.image.textbox.zoom a img')

# doc = Nokogiri::HTML(open('http://imgur.com/5JFfV'))


####
# Search for nodes by css
# doc.css('.image.textbox.zoom a img').each do |link|
# puts link['src']
# end
# puts "#{doc}"

# scrapper.run

# class A
#   def initialize(str)
#     @str = str
#   end

#   def hola
#     "instance"
#   end


#   def to_s
#     @str
#   end

#   def self.hola
#     "class"
#   end

#   def str
#     puts "str"
#     @str
#   end

#   def str=(value)
#     @str = value
#   end

# end
