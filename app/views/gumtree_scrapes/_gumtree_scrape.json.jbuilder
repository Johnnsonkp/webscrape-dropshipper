json.extract! gumtree_scrape, :id, :url, :title, :description, :link, :link_src, :price, :location, :website, :created_at, :updated_at
json.url gumtree_scrape_url(gumtree_scrape, format: :json)
