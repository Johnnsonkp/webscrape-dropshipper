class CreateGumtreeScrapes < ActiveRecord::Migration[7.1]
  def change
    create_table :gumtree_scrapes do |t|
      t.string :url
      t.string :title
      t.text :description
      t.string :link
      t.string :link_src
      t.string :price
      t.string :location
      t.string :website

      t.timestamps
    end
  end
end
