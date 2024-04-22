require 'selenium-webdriver'
require 'nokogiri'
require 'watir'
require 'net/http'
require 'timeout'
require 'open-uri'
require 'parallel'
require 'thread/pool'


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

            # puts "@scraped_data:, #{ @scraped_data}"

            @scraped_data.each do |listing_params|
              GumtreeScrape.create(listing_params)
            end
            redirect_to '/gumtree_scrapes', notice: "Listing successfully scraped."
        else 
            puts "bad requesting. Redirecting..."
            redirect_to '/', alert: "Error! please enter a valid Gumtree URL."; return
        end
    end

    def updates
        
    end

    def price_increase
      if @scraped_data.present?
        @scraped_data.each do |item|
          item.price = BigDecimal(item.price) * (1 + 0.40)
          puts "item.price, #{item.price}"
        end 
      end
    end 

    def stores
      
    end 

    private

    def set_url_and_quantity
      @url = @url || "Enter URL to be scraped"  
      @quantity = @quantity || '1'
    end

    def validate_url_params(entered_url)
      valid_patterns = /\A(?:https:\/\/www\.gumtree\.com\.au\/s|gumtree\.com\.au\/s)/
      entered_url.match?(valid_patterns)
    end

    def fetch_html_content(url)
        URI.open(url).read
      rescue StandardError => e
        puts "Error fetching HTML content: #{e.message}"
        nil
    end



    def process_scrape_after_error(html_content, quantity)
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
    
                listings << {
                  title: title,
                  description: description,
                  price: price,
                  location: location,
                  link: link,
                  link_src: '',
                  url: @url,
                  website: 'Gumtree.com'
                }
              rescue StandardError => e
                puts "Error processing listing: #{e.message}"
              end
            end
        end
        threads.each(&:join)
        puts "Listings size: #{listings.size}"
        listings
    end



    def process_scrape(html_content, quantity)
      return [] unless html_content
      
      puts "Processing scrape..."
      
      doc = Nokogiri::HTML(html_content)
      listings = []
      newLinkArr = []
      # @listings = []
      mutex = Mutex.new 
      thread_pool = Thread.pool(quantity) # Adjust the pool size based on your system's capability

      links = doc.css('.user-ad-collection-new-design__wrapper--row a').to_a.shuffle
      newLinks = links.select { |link| !link['class']&.include?('user-ad-row-new-design--highlight') }
      # puts "newLink created #{newLinks}"
      quantity.times do |i|
        element = newLinks[i]
        thread_pool.process(element) do |element|
          begin
            title = element.at_css('.user-ad-row-new-design__title-span').text
            description = element.at_css('.user-ad-row-new-design__description-text').text
            price = element.at_css('.user-ad-price-new-design__price').text
            location = element.at_css('.user-ad-row-new-design__location').text
            link = "https://www.gumtree.com.au#{element['href']}"
            puts "title, #{title}"
            
            mutex.synchronize do 
              puts "In Mutex, #{link}"

              options = Selenium::WebDriver::Chrome::Options.new
              options.add_argument("--headless")
              options.add_argument("--disable-gpu")
              options.add_argument("--no-sandbox")
              options.add_argument("--disable-dev-shm-usage")
              
              driver = Selenium::WebDriver.for :chrome, options: options
              driver.manage.timeouts.page_load = 60 # Set page load timeout to 30 seconds
              driver.navigate.to link
              puts "Driver navigating to link...., #{link}"
              # Implement retry mechanism
              retries = 2
              begin
                # sleep 5 # Consider replacing this with a wait condition for the element to be present
                wait = Selenium::WebDriver::Wait.new(timeout: 10) # Adjust timeout as needed
                # wait.until { driver.find_element(:css, '.vip-ad-image__main-image--is-visible') }
                # img_src = driver.find_element(:css, '.vip-ad-image__main-image--is-visible')
                # img_src_attribute = img_src.attribute("src")

                wait.until { driver.find_element(:css, '.vip-ad-image__main-image-background') }
                img_src = driver.find_element(:css, '.vip-ad-image__main-image-background')
                img_src_attribute = img_src['style']

                img_src_attribute = img_src_attribute.match(/url\((['"])?(.*?)\1\)/)[2]

                puts "begin img_src_attribute: #{img_src_attribute}"

              rescue Net::ReadTimeout => e
                retries -= 1
                if retries > 0
                  puts "Timeout occurred, retrying..."
                  retry
                else
                  puts "Error processing listing image: #{e.message}"
                  img_src_attribute = ""
                  next # Skip the problematic listing 
                  # Need to implement AI image generation here
                end
              end
              
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
              puts "finished listing, #{listings}"
            end
          rescue StandardError => e
            puts "Error processing listing: #{e.message}"
          ensure
            driver.quit if driver
          end
        end
    end
      thread_pool.shutdown
      puts "Listings size: #{listings.size}"

      if listings && listings.size > 0
        puts "if listings && listings.size"
        return listings
      else 
        puts "else if listings && listings.size" 
        process_scrape_after_error(html_content, quantity)
      end 

    end
end

