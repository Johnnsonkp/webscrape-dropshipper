require 'selenium-webdriver'
require 'nokogiri'
require 'watir'
require 'net/http'
require 'timeout'
require 'open-uri'
require 'parallel'


class HomeController < ApplicationController
  before_action :set_url_and_quantity, only: %i[ search ]
    def index
        @gumtree_scrapes = GumtreeScrape.all
    end

    def search
        
    end

    def update_url
        if validate_url_params(params[:url].strip)
            @url = params[:url].strip
            quantity = params[:quantity].to_i
          
            html_content = fetch_html_content(@url)
            @scraped_data = process_scrape(html_content, quantity)


            @scraped_data.each do |listing_params|
              GumtreeScrape.create(listing_params)
            end
        else 
            puts "bad requesting. Redirecting..."
            redirect_to '/', alert: "Error! please enter a valid Gumtree URL."; return
        end
    end

    def price_increase
      if @scraped_data.present?
        @scraped_data.each do |item|
          item.price = BigDecimal(item.price) * (1 + 0.40)
          puts "item.price, #{item.price}"
        end 
      end
    end 

    private

    def set_url_and_quantity
      @url = @url || "Enter URL to be scraped"  
      @quantity = @quantity || '1'
    end

    def validate_url_params(entered_url)
        valid_patterns = /\A(?:https:\/\/www\.gumtree\.com\.au\/s|gumtree\.com\.au\/s)/
        if entered_url && entered_url.match?(valid_patterns)
            puts "url pattern valid: "
            return true
        else  
            puts "url pattern is invalid "
            return false 
        end
    end

    def fetch_html_content(url)
        URI.open(url).read
      rescue StandardError => e
        puts "Error fetching HTML content: #{e.message}"
        nil
    end


    def process_scrape(html_content, quantity)
        return unless html_content
        
        doc = Nokogiri::HTML(html_content)
        puts "Processing scrape..."
      
        listings = []
        threads = []
        mutex = Mutex.new  # Create a mutex lock
        
        doc.css('.user-ad-collection-new-design__wrapper--row a').first(quantity).each do |element|
          threads << Thread.new do
            begin
              title = element.at_css('.user-ad-row-new-design__title-span').text
              description = element.at_css('.user-ad-row-new-design__description-text').text
              price = element.at_css('.user-ad-price-new-design__price').text
              location = element.at_css('.user-ad-row-new-design__location').text
              link = "https://www.gumtree.com.au#{element['href']}"
              
              src_options = Selenium::WebDriver::Chrome::Options.new
              src_options.add_argument("--headless")
              src_options.add_argument("--disable-extensions")
              src_options.add_argument('--disable-application-cache')
              src_options.add_argument('--disable-gpu')
              src_options.add_argument("--no-sandbox")
              src_options.add_argument("--disable-setuid-sandbox")
              src_options.add_argument("--disable-dev-shm-usage")

            mutex.synchronize do  # Lock the mutex before executing code block
              src_drive_init = Selenium::WebDriver.for :chrome, options: src_options
              src_drive_init.navigate.to link
              
              sleep 5 # Set delay to give time to locate css selector
              img_src = src_drive_init.find_element(:css, '.vip-ad-image__main-image--is-visible')
              img_src_attribute = img_src.attribute("src")
              
              listings << {
                title: title,
                description: description,
                price: price,
                location: location,
                link: link,
                link_src: img_src_attribute,
                url: @url,
                website: 'Gumtree.com'
              }
              src_drive_init.quit if src_drive_init
            end
          rescue StandardError => e
            puts "Error processing listing: #{e.message}"
          end
          end
        end
      
        threads.each(&:join)
        puts "Listings size: #{listings.size}"
        listings
    end
end
