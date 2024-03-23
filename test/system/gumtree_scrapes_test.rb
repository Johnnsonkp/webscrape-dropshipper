require "application_system_test_case"

class GumtreeScrapesTest < ApplicationSystemTestCase
  setup do
    @gumtree_scrape = gumtree_scrapes(:one)
  end

  test "visiting the index" do
    visit gumtree_scrapes_url
    assert_selector "h1", text: "Gumtree scrapes"
  end

  test "should create gumtree scrape" do
    visit gumtree_scrapes_url
    click_on "New gumtree scrape"

    fill_in "Description", with: @gumtree_scrape.description
    fill_in "Link", with: @gumtree_scrape.link
    fill_in "Link src", with: @gumtree_scrape.link_src
    fill_in "Location", with: @gumtree_scrape.location
    fill_in "Price", with: @gumtree_scrape.price
    fill_in "Title", with: @gumtree_scrape.title
    fill_in "Url", with: @gumtree_scrape.url
    fill_in "Website", with: @gumtree_scrape.website
    click_on "Create Gumtree scrape"

    assert_text "Gumtree scrape was successfully created"
    click_on "Back"
  end

  test "should update Gumtree scrape" do
    visit gumtree_scrape_url(@gumtree_scrape)
    click_on "Edit this gumtree scrape", match: :first

    fill_in "Description", with: @gumtree_scrape.description
    fill_in "Link", with: @gumtree_scrape.link
    fill_in "Link src", with: @gumtree_scrape.link_src
    fill_in "Location", with: @gumtree_scrape.location
    fill_in "Price", with: @gumtree_scrape.price
    fill_in "Title", with: @gumtree_scrape.title
    fill_in "Url", with: @gumtree_scrape.url
    fill_in "Website", with: @gumtree_scrape.website
    click_on "Update Gumtree scrape"

    assert_text "Gumtree scrape was successfully updated"
    click_on "Back"
  end

  test "should destroy Gumtree scrape" do
    visit gumtree_scrape_url(@gumtree_scrape)
    click_on "Destroy this gumtree scrape", match: :first

    assert_text "Gumtree scrape was successfully destroyed"
  end
end
