require 'nokogiri'
require 'open-uri'
require 'thread'

# class Scraper
  def scrape_page(url)
    doc = Nokogiri::HTML(URI.open(url))

    threads = []
    doc.css('.user-ad-row').each do |item|
      threads << Thread.new do
        title = item.at_css('.user-ad-row__title').text.strip
        price = item.at_css('.user-ad-price__price').text.strip
        location = item.at_css('.user-ad-row__location').text.strip
        description = item.at_css('.user-ad-row__description').text.strip

        item_url = item.at_css('.user-ad-row__title a')['href']
        item_doc = Nokogiri::HTML(URI.open("#{item_url}"))
        image_url = item_doc.at_css('.vip-ad-image img')['src']

        puts "Title: #{title}"
        puts "Price: #{price}"
        puts "Image URL: #{image_url}"
        puts "Location: #{location}"
        puts "Description: #{description}"
        puts "------------------------"
      end
    end

    threads.each(&:join)
  end
# end

# scraper = Scraper.new
# scraper.

scrape_page('https://www.gumtree.com.au/s-melbourne-city/macbooks/k0l3001571r10')

