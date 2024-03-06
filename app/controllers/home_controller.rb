require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'nokogiri'
require 'watir'
require 'net/http'
require 'timeout'
require 'net/http'

class HomeController < ApplicationController
    before_action :initialise_driver
    # before_action :set_url, only: [:index, :update_url]
    # before_action -> { perform_scraping_logic(@url) }, only: [ :index, :update_url]

    include Capybara::DSL

    def index
        @scraped_data = perform_scraping_logic(@url)

        respond_to do |format|
            format.html
            format.json { render json: { scraped_data: @scraped_data } }
        end
    end

    def search
                
    end


    def update_url
        url = params[:url]
        if validate_url_params(url)
            @url = params[:url] 
            @scraped_data = perform_scraping_logic(@url)
        else 
            puts "bad requesting. Redirecting..."
            redirect_to '/', alert: "Error! please enter a valid Gumtree URL."
        end
    end

    private

    def set_url
        @url = "https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20"
    end


    def initialise_driver
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument("--headless")
        @driver = Selenium::WebDriver.for :chrome, options: options
    end

    def validate_url_params(entered_url)
        valid_patterns = /\A(?:https:\/\/www\.gumtree\.com\.au\/s|gumtree\.com\.au\/s)/
        if entered_url.match?(valid_patterns)
            return true
        else  
            return false 
        end
    end

    def get_src_from_saved_txt_file(file)
        html_content = File.read(file)
        doc = Nokogiri::HTML(html_content)
        images = doc.css('img')
        print "#{images[0]['src']}"
    end

    # def scrape_url_convert_to_txt_file(url_lnk)
    #     url = url_lnk || "https://www.gumtree.com.au/s-men-s-shoes/melbourne-city/jordan/k0c18573l3001571"
    #     puts "URL initialize: #{url}"
        
    #     # Configure Capybara to use Selenium with a headless browser
    #     Capybara.register_driver :selenium do |app|
    #       Capybara::Selenium::Driver.new(app, browser: :chrome)
    #     end
    
    #     Capybara.default_driver = :selenium
    #     visit url
    #     execute_script("window.scrollTo(0, document.body.scrollHeight);")
    #     has_css?('.image--is-visible', wait: 20)
    
    #     # Get the page source after the element has been dynamically rendered
    #     page_source = page.body
    #     File.open("docContent2.txt", "w") { |f| f.write "#{page_source}" }

    #     # return page_source

    #     Capybara.reset_sessions!
    #     Capybara.use_default_driver
    # end

    def scrape_url_to_file(url_link) 
        begin 
            url = url_link
            @driver.navigate.to url
            
            html_content_wrapper = @driver.find_elements(:css, '.user-ad-collection-new-design__wrapper--row a') 
            scraped_selenuim = html_content_wrapper

            process_scrape(scraped_selenuim)
        
        rescue Net::ReadTimeout 
            redirect_to '/', alert: "The request timed out. Please try again later."
        rescue StandardError => e  
            redirect_to '/', alert: "The StandardError. #{e.message}"
        end 
    end

    def process_scrape(content)
        @title = []
        @description = []
        @price = []
        @location = []
        @link = []
        @link_src = []
        
        content.each do |element|
            @title << element.find_element(:css, ".user-ad-row-new-design__title-span").text
            @description << element.find_element(:css, ".user-ad-row-new-design__description-text").text
            @price << element.find_element(:css, ".user-ad-price-new-design__price").text
            @location << element.find_element(:css, ".user-ad-row-new-design__location").text
            @link << element.attribute("href")
            # @link_src << @dynamic_img
        end
    end

    def perform_scraping_logic(url) 
        if url
            scrape_url_to_file(url)
            @driver.quit
            puts " @driver.quit:"
            new_listings_array = @title.map.with_index do |t, i|
                {
                title: @title[i],
                description: @description[i],
                price: @price[i],
                location: @location[i],
                link: @link[i],
                # link_to_img_src: @link_src[i]
                }
            end

            puts " Scrape finished [DONE]"
            return new_listings_array
        end
    end
end
