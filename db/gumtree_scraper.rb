require 'watir'
require 'webdrivers'
require 'nokogiri'

browser = Watir::Browser.new
browser.goto 'https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20'
parsed_page = Nokogiri::HTML(browser.html)

File.open("fridge_gumtree_parsed.txt", "w") { |f| f.write "#{parsed_page.css('.user-ad-collection-new-design__wrapper--row')}" }


title = parsed_page.css('.user-ad-row-new-design__title-span')

puts title

browser.close


# title class --> .user-ad-row-new-design__title-span
# price class --> .user-ad-price-new-design__price
# location class --> .user-ad-row-new-design__location
# description class --> .user-ad-row-new-design__description-text
# Image class --> .user-ad-image__thumbnail image image--is-visible