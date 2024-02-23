class HomeController < ApplicationController
    before_action :set_url, only: [:index, :search, :update_url]
    before_action -> { perform_scraping_logic(@url) }, only: [ :index, :search]

    def index
        @scraped_data = perform_scraping_logic(@url)
        # puts "Index:  #{@scraped_data}"

        respond_to do |format|
            format.html
            format.json { render json: { scraped_data: @scraped_data } }
        end
    end

    def search
        puts "search:  #{@url}"
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
    
    def perform_scraping_logic(url) 
        require 'watir'
        require 'webdrivers'
        require 'nokogiri'
        require 'net/http'

        # browser = Watir::Browser.new :chrome
        # browser.goto'https://www.gumtree.com.au/s-men-s-shoes/melbourne-city/jordan/k0c18573l3001571'
        


        # browser.close
        if url

            
            # js_doc = browser.element(css: '.user-ad-image__thumbnail').wait_until(&:present?)
            # dynamic_image = Nokogiri::HTML(js_doc.inner_html)
            # desired_image = doc.css('.user-ad-image__thumbnail')['src']

            # parsed_page = Nokogiri::HTML(browser.html)

            response = Net::HTTP.get_response(URI(url))

            if response.code != "200"
                puts "Error: #{response.code}"
                exit
            end

            # HTML Parser
            doc = Nokogiri::HTML(response.body)

            title = []
            description = []
            price = []
            location = []
            link = []
            listings_array = []
            
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


            # listing_link_test_arr = doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-image__thumbnail')['src']

            # listing_link_test_arr = browser.element(css: '.user-ad-collection-new-design__wrapper--row a .user-ad-image__thumbnail').wait_until(&:present?) 

            # test_image = doc.css('.user-ad-image__thumbnail')['src']
            
            # doc.css('.user-ad-collection-new-design__wrapper--row a .user-ad-image__thumbnail')['src']


            puts "Listing link test:///////////////////////////////////////////////////////////////////////////////////////////"

            # puts "Listing link test:, #{desired_image} "

            puts "Listing link test:///////////////////////////////////////////////////////////////////////////////////////////"



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
                listings_array << [title[i], description[i], price[i], location[i], link[i]]
            end

            new_listings_array = title.map.with_index do |t, i|
                {
                title: title[i],
                description: description[i],
                price: price[i],
                location: location[i],
                link: link[i]
                }
            end
        
            return new_listings_array

        end

    end

    

end
