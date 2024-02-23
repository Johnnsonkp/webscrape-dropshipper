require 'watir'
require 'webdrivers'
require 'nokogiri'

browser = Watir::Browser.new
# browser.goto 'https://blog.eatthismuch.com/latest-articles/'
browser.goto 'https://www.gumtree.com.au/s-men-s-shoes/melbourne-city/jordan/k0c18573l3001571'
parsed_page = Nokogiri::HTML(browser.html)


# File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }
File.open("jordans_parsed.txt", "w") { |f| f.write "#{parsed_page}" }

links = parsed_page.css('a')
description = parsed_page.css('.td-excerpt')

links.map {|element| element["href"]}
# description.map {|text_content| text_content.text.strip}


puts parsed_page.title
description.map {|text_content| puts text_content.text.strip}
# puts links
# puts description

browser.close