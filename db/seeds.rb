# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Seed data for GumtreeScrape
seed_data = [
    {
      url: "https://www.gumtree.com.au/s-men-s-shoes/jordans/k0c18573r10",
      title: "Jordan 3 retro blue racer",
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce quis lectus auctor, malesuada elit eu, ultrices nulla.",
      link: "https://www.gumtree.com.au/s-ad/melbourne-cbd/men-s-shoes/jordan-3-retro-blue-racer/1322971941",
      link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/37e301ba-dafa-454d-bec7-3a479042f476.jpg",
      price: "$350",
      location: "Melbourne CBD, VIC",
      website: "Gumtree"
    },
    {
      url: "https://www.gumtree.com.au/s-men-s-shoes/jordans/k0c18573r10",
      title: "Jordan 4 raptors",
      description: "Sed gravida tortor non placerat dictum. Nulla consectetur mi sit amet malesuada efficitur.",
      link: "https//www.gumtree.com.au/s-ad/melbourne-cbd/men-s-shoes/jordan-4-raptors/1322912174",
      link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/7475d5f8-9c92-48d4-a1af-9fdc1ba095db.jpg",
      price: "$250",
      location: "Melbourne CBD, VIC",
      website: "Gumtree"
    },
    {
        url: "https://www.gumtree.com.au/s-men-s-shoes/jordans/k0c18573r10",
        title: "Jordan 3 retro blue racer",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce quis lectus auctor, malesuada elit eu, ultrices nulla.",
        link: "https://www.gumtree.com.au/s-ad/melbourne-cbd/men-s-shoes/jordan-3-retro-blue-racer/1322971941",
        link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/37e301ba-dafa-454d-bec7-3a479042f476.jpg",
        price: "$350",
        location: "Melbourne CBD, VIC",
        website: "Gumtree"
      },
      {
        url: "https://www.gumtree.com.au/s-men-s-shoes/jordans/k0c18573r10",
        title: "Jordan 4 raptors",
        description: "Sed gravida tortor non placerat dictum. Nulla consectetur mi sit amet malesuada efficitur.",
        link: "//www.gumtree.com.au/s-ad/melbourne-cbd/men-s-shoes/jordan-4-raptors/1322912174",
        link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/7475d5f8-9c92-48d4-a1af-9fdc1ba095db.jpg",
        price: "$250",
        location: "Melbourne CBD, VIC",
        website: "Gumtree"
      },
      {
        url: "https://www.gumtree.com.au/s-men-s-shoes/jordans/k0c18573r10",
        title: "Jordan 3 retro blue racer",
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce quis lectus auctor, malesuada elit eu, ultrices nulla.",
        link: "https://www.gumtree.com.au/s-ad/melbourne-cbd/men-s-shoes/jordan-3-retro-blue-racer/1322971941",
        link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/37e301ba-dafa-454d-bec7-3a479042f476.jpg",
        price: "$350",
        location: "Melbourne CBD, VIC",
        website: "Gumtree"
      },
      {
        url: "https://www.gumtree.com.au/s-watches/k0c18605r10",
        title: "Oysterdate Precision 1972",
        description: "Beautiful example of an early 70’s Oysterdate Precision. Warm, cream/silver dial with date window. Movement keeps excellent time. Purchased from a well rated dealer and protected by Chrono24’s authenticity assurances.", 
        price: "$3,700",
        location: "White Gum Valley, WA",
        link: "https://www.gumtree.com.au/s-ad/white-gum-valley/watches/oysterdate-precision-1972/1321863861",
        link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/0bd1155a-ab8b-412d-9ad9-f51a8f1dfe9b.jpg",
        website: "Gumtree"
      },
      {
        url: "https://www.gumtree.com.au/s-watches/k0c18605r10",
        title: "Apple Watch 9Series GPS Brand New",
        description: "Brand New, never worn or used. Without packaging and cord. Pink band.", 
        price: "$500",
        location: "Templestowe, VIC",
        link: "https://www.gumtree.com.au/s-ad/templestowe/watches/apple-watch-9series-gps-brand-new/1322432212",
        link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/d65123f6-9190-44b6-acdb-fa631831a18f.jpg",
        website: "Gumtree"
      },
      {
        url: "https://www.gumtree.com.au/s-watches/k0c18605r10",
        title: "Apple Watch 9Series GPS Brand New",
        description: "Brand New, never worn or used. Without packaging and cord. Pink band.", 
        price: "$500",
        location: "Templestowe, VIC",
        link: "https://www.gumtree.com.au/s-ad/templestowe/watches/apple-watch-9series-gps-brand-new/1322432212",
        link_src: "https://gumtreeau-res.cloudinary.com/image/private/t_$_s-l800/gumtree/d65123f6-9190-44b6-acdb-fa631831a18f.jpg",
        website: "Gumtree"
      },
  ]
  

  #delete_exsiting data
  GumtreeScrape.destroy_all


  # Create GumtreeScrape instances
  if GumtreeScrape.count == 0
    seed_data.each do |data|
      GumtreeScrape.create!(data)
    end
  end
