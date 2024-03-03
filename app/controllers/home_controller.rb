require 'capybara'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'nokogiri'
require 'watir'
require 'net/http'
require 'timeout'

class HomeController < ApplicationController
    before_action :set_url, only: [:index, :search, :update_url]
    before_action -> { perform_scraping_logic(@url) }, only: [ :index, :search]

    include Capybara::DSL

    def index
        @scraped_data = perform_scraping_logic(@url)
        # puts "Index:  #{@scraped_data}"

        respond_to do |format|
            format.html
            format.json { render json: { scraped_data: @scraped_data } }
        end
    end

    def search
        puts "search: #{@url}"
        @scraped_data = perform_scraping_logic(@url)
    end

    def update_url
        @url = params[:url] || "https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20"
        @scraped_data = perform_scraping_logic(@url)
    end

    private

    def set_url
        @url = "https://www.gumtree.com.au/s-melbourne-city/fridge/k0l3001571r20"
    end

    def get_src_from_saved_txt_file(file)
        html_content = File.read(file)
        doc = Nokogiri::HTML(html_content)
        images = doc.css('img')
        print "#{images[0]['src']}"
    end

    def scrape_url_convert_to_txt_file(url_lnk)
        url = url_lnk || "https://www.gumtree.com.au/s-men-s-shoes/melbourne-city/jordan/k0c18573l3001571"
        puts "URL initialize: #{url}"
        
        # Configure Capybara to use Selenium with a headless browser
        Capybara.register_driver :selenium do |app|
          Capybara::Selenium::Driver.new(app, browser: :chrome)
        end
    
        Capybara.default_driver = :selenium
        visit url
        execute_script("window.scrollTo(0, document.body.scrollHeight);")
        has_css?('.image--is-visible', wait: 20)
    
        # Get the page source after the element has been dynamically rendered
        page_source = page.body
        File.open("docContent2.txt", "w") { |f| f.write "#{page_source}" }
        # localStorage.setItem("store_website_html", JSON.parse(pageSource));

        Capybara.reset_sessions!
        Capybara.use_default_driver
    end
    # include Capybara::DSL

    def perform_scraping_logic(url) 

        if url

            # scrape_url_convert_to_txt_file(url)

            # file_path = '/docContent.txt'
            # localStorage_data = localStorage.getItem("store_website_html");

            text_content = File.read("docContent.txt")
            # content = '/db/output.html'
            
            # response = Net::HTTP.get_response(URI(url))
            # if response.code != "200"
            #     puts "Error: #{response.code}"
            #     exit
            # end
            # HTML Parser
            # doc = Nokogiri::HTML(response.body)
            doc = Nokogiri::HTML(text_content)
            doc = doc.css('#react-root')

            title = []
            description = []
            price = []
            location = []
            link = []
            link_to_img_src = []
            link_to_img_src_arr = []
            listings_array = []
            first_link_to_img_src = []
            
            # locations
            listing_location_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-row-new-design__location')
            # Listing description 
            listing_description_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-row-new-design__description-text')
            # Listing price 
            listing_price_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-price-new-design__price')
            # listing picture // link
            listing_link_arr = doc.css('.user-ad-collection-new-design__wrapper--row a')
            # Listing Title
            listing_title_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-row-new-design__title-span')

            link_to_img_src = doc.css('.user-ad-collection-new-design__wrapper--row a .image--is-visible')
            # link_to_img_src = []

            # listing_link_arr.each do |node|

            #     if(node.css('img')[0] && node.css('img')[0]['src'])
            #         img_tag_test = node.css('img')[0]['src']

            #         link_to_img_src.push(img_tag_test)
            #     end

            #     puts "link_to_img_src, #{link_to_img_src}"
            # end


            # link_to_img_src = doc.css('.user-ad-collection-new-design__wrapper--row a img.user-ad-image__thumbnail')

            # item_container = doc.css('.user-ad-collection-new-design__wrapper--row a')


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

            # puts "link_to_img_src.length: #{link_to_img_src.length}"

            link_to_img_src.each do |node| 
                # img_tag_test = node.css('img')[0] && node.css('img')[0]['src'] || node.css('img')[1] && node.css('img')[1]['src']

                link_to_img_src_arr.push(node['src'])

                # print "link_to_img_src: #{node['src']} " + '/n'
            end

            link_to_img_src

            # for i in 0..title.length - 1 
            #     listings_array << [title[i], description[i], price[i], location[i], link[i], link_to_img_src_arr[i]]  
            # end

            for i in 0..title.length - 1 
                listings_array << [title[i], description[i], price[i], location[i], link[i], link_to_img_src[0]]  
            end

            new_listings_array = title.map.with_index do |t, i|
                {
                title: title[i],
                description: description[i],
                price: price[i],
                location: location[i],
                link: link[i],
                link_to_img_src: link_to_img_src_arr[i]
                }
            end

            # new_listings_array = title.map.with_index do |t, i|
            #     {
            #     title: title[i],
            #     description: description[i],
            #     price: price[i],
            #     location: location[i],
            #     link: link[i],
            #     link_to_img_src: link_to_img_src[i]
            #     }
            # end

            # puts "ink_to_img_src_arr.length: #{lnew_listings_array[:link_to_img_src]}"
            # puts "ink_to_img_src_arr.length: #{link_to_img_src_arr.length}"
            # puts "title.length: #{title.length}"
            return new_listings_array
        end
    end
end
