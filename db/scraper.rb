require 'watir'
require 'selenium-webdriver'
require 'nokogiri'
require 'watir'
require 'net/http'
require 'timeout'
require 'open-uri'
require 'parallel'

# File.open("parsed.txt", "w") { |f| f.write "#{parsed_page}" }
# File.open("jordans_new_parsed.txt", "w") { |f| f.write "#{parsed_page}" }
# Selenium::WebDriver::Chrome::Service.driver_path = '/path/to/chromedriver'

class Listing
    attr_accessor :title, :description, :price, :location, :link, :link_src
  
    def initialize(title, description, price, location, link, link_src)
      @title = title
      @description = description
      @price = price
      @location = location
      @link = link
      @link_src = link_src
    end
  
    def display_listing_info
        print "------------------------------------------------------------------------------ \n"
        puts "Title: #{@title}"
        puts "Description: #{@description}"
        puts "Price: #{@price}"
        puts "Location: #{@location}"
        puts "Link: #{@link}"
        puts "Link_src: #{@link_src}"
        print "------------------------------------------------------------------------------ \n"
    end
end

def process_scrape(html_content)
    doc = Nokogiri::HTML(html_content)
    puts "Processing scrape..."
    threads = []
    listing = []
  
    doc.css('.user-ad-collection-new-design__wrapper--row a').first(3).each_with_index do |element, index|
      threads << Thread.new do

        title = element.at_css('.user-ad-row-new-design__title-span').text
        description = element.at_css('.user-ad-row-new-design__description-text').text
        price = element.at_css('.user-ad-price-new-design__price').text
        location = element.at_css('.user-ad-row-new-design__location').text
        link =  "https://www.gumtree.com.au#{element['href']}"

        puts "Title: #{title}"
        # Navigate to the link only once per element
        img_sources = ""
        begin
          # Create a new WebDriver instance for each thread
            src_options = Selenium::WebDriver::Chrome::Options.new
            src_options.add_argument("--headless")
            src_options.add_argument("--disable-extensions")
            src_options.add_argument('--disable-application-cache')
            src_options.add_argument('--disable-gpu')
            src_options.add_argument("--no-sandbox")
            src_options.add_argument("--disable-setuid-sandbox")
            src_options.add_argument("--disable-dev-shm-usage")

            src_drive_init = Selenium::WebDriver.for :chrome, options: src_options
            src_drive_init.navigate.to link  
            
            sleep 5 #// set delay to give time to locate css selector

            img_src = src_drive_init.find_element(:css, '.vip-ad-image__main-image--is-visible')
            img_sources = img_src.attribute("src") || ""

            sleep 5 
        rescue StandardError => e
            puts "Error processing listing #{index}: #{e.message}"
        ensure
            src_drive_init.quit if src_drive_init
        end
        listing << Listing.new(title, description, price, location, link, img_sources)
      end
    
    end
    threads.each(&:join)
    # puts "Listing: #{listings_array[index].display_listing_info}"
    listing.each do |list|
        puts "Listing: #{list.display_listing_info}"
    end

    return listing
end   


html_content = URI.open("https://www.gumtree.com.au/s-watches/k0c18605r10").read
@data = process_scrape(html_content)

