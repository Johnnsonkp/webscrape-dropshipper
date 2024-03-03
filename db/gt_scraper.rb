# require 'watir'
require 'webdrivers'
require 'nokogiri'
require 'net/http'

# HTTP Client
url = 'https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20'
response = Net::HTTP.get_response(URI(url))

if response.code != "200"
    puts "Error: #{response.code}"
    exit
end

# HTML Parser
doc = Nokogiri::HTML(response.body)
    listing_location_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-row-new-design__location')
    listing_description_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-row-new-design__description-text')
    listing_price_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-price-new-design__price')
    # listing picture // link
    listing_link_arr = doc.css('.user-ad-collection-new-design__wrapper--row a')
    listing_title_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-row-new-design__title-span')

class Listing
    attr_accessor :title, :description, :price, :location, :link
  
    def initialize(title, description, price, location, link)
      @title = title
      @description = description
      @price = price
      @location = location
      @link = link
    end
  
    def display_listing_info
        print "------------------------------------------------------------------------------ \n"
        puts "Title: #{@title}"
        puts "Description: #{@description}"
        puts "Price: #{@price}"
        puts "Location: #{@location}"
        puts "Link: #{@link}"
        print "------------------------------------------------------------------------------ \n"
    end

    def display_title
        puts "Title: #{@title}"
    end
    def display_description
        puts "Description: #{@description}"
    end
    def display_price
        puts "Price: #{@price}"
    end
    def display_location
        puts "Location: #{@location}"
    end
    def display_link
        puts "Link: #{@link}"
    end
end

title = []
description = []
price = []
location = []
link = []
listings_array = []

listing_title_arr.each do |node| 
    title.push(node.content)
end
listing_description_arr.each do |node| 
    description.push(node.content)
end
listing_price_arr.each do |node| 
    price.push(node.content)
end
listing_location_arr.each do |node| 
    location.push(node.content)
end
listing_link_arr.each do |node| 
    href_attri = node['href']
    link.push("https://www.gumtree.com.au" + href_attri)
end

for i in 0..title.length - 1 
    listings_array << Listing.new(title[i], description[i], price[i], location[i], link[i])
end

# listings_array.each do |listing|
#     listing.display_listing_info
#     listing.display_title
# end


url_link = "https://www.gumtree.com.au/s-ad/carlton-north/fridges-freezers/smart-fridge/1322223658"
# response_link = Net::HTTP.get_response(URI(url_link))
html_content = open(url_link)

if html_content.code != "200"
    puts "Error: #{html_content.code}"
    exit
end

# HTML Parser
link_doc = Nokogiri::HTML(html_content)
# locations
listing_link_img = doc.at('.vip-ad-image__main-image vip-ad-image__main-image--is-visible')

if listing_link_img
    href_value = listing_link_img['href']
    puts "Href value: #{href_value}"
  else
    puts "Element not found."
end