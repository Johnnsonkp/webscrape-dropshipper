require 'watir'
# require 'webdrivers'
require 'nokogiri'
require 'net/http'
require 'timeout'

# Set up Selenium WebDriver
driver = Selenium::WebDriver.for :chrome
url = 'https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20'  # Replace with the URL of the page you want to scrape
driver.navigate.to(url)

# Set up Nokogiri
wait = Selenium::WebDriver::Wait.new(timeout: 10)  # Adjust the timeout as needed

begin
  # Wait for the element with the specified CSS class
  elements = wait.until { driver.find_elements(css: '.user-ad-image__wrapper') }
#   elements = wait.until { driver.find_elements(css: '.image--is-visible') }

  elements.each do |element|
    # Use Nokogiri to parse the HTML of each element
    nokogiri_doc = Nokogiri::HTML(element.attribute('outerHTML'))

    # Now you can work with nokogiri_doc to extract information from the HTML of each element
    # For example, you can get the image source URL:
    # image_src = nokogiri_doc.at_css('img')['src']
    image_src = nokogiri_doc.at_css('.image--is-visible')
    # image_src = nokogiri_doc.at_css('img')
    puts "Image source URL: #{image_src}"
  end

ensure
  driver.quit  # Close the browser when done
end



# browser = Watir::Browser.new
# browser.goto 'https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20'
# parsed_page = Nokogiri::HTML(browser.html)
# js_doc = browser.element(css: '.image--is-visible').wait_until(&:present?)
# js_doc = browser.element(css: '.user-ad-image__wrapper').wait_until(&:present?)
# parsed_selector = Nokogiri::HTML(js_doc.inner_html)
# desired_image = doc.css('.user-ad-image__wrapper')

# if js_doc
#     puts js_doc
# end

# if parsed_selector
#     image_src = doc.css(".user-ad-image__main-image-wrapper img")
#     puts "desired_image: #{image_src}"
# end

# browser = Watir::Browser.new 
# browser.goto'https://www.gumtree.com.au/s-men-s-shoes/melbourne-city/jordan/k0c18573l3001571'
# js_doc = browser.element(css: '.image--is-visible').wait_until(&:present?)



# File.open("fridge_gumtree_parsed.txt", "w") { |f| f.write "#{parsed_page.css('.user-ad-collection-new-design__wrapper--row')}" }


# title = parsed_page.css('.user-ad-row-new-design__title-span')

# puts title

# browser.close


# title class --> .user-ad-row-new-design__title-span
# price class --> .user-ad-price-new-design__price
# location class --> .user-ad-row-new-design__location
# description class --> .user-ad-row-new-design__description-text
# Image class --> .user-ad-image__thumbnail image image--is-visible