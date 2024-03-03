require 'watir'
# require 'webdrivers'
require 'nokogiri'

browser = Watir::Browser.new
# browser.goto 'https://blog.eatthismuch.com/latest-articles/'
browser.goto 'https://www.gumtree.com.au/s-men-s-shoes/melbourne-city/jordan/k0c18573l3001571'
parsed_page = Nokogiri::HTML(browser.html)


# File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }
File.open("jordans_new_parsed.txt", "w") { |f| f.write "#{parsed_page}" }


browser.close

