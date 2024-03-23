require "test_helper"

class GumtreeScrapesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gumtree_scrape = gumtree_scrapes(:one)
  end

  test "should get index" do
    get gumtree_scrapes_url
    assert_response :success
  end

  test "should get new" do
    get new_gumtree_scrape_url
    assert_response :success
  end

  test "should create gumtree_scrape" do
    assert_difference("GumtreeScrape.count") do
      post gumtree_scrapes_url, params: { gumtree_scrape: { description: @gumtree_scrape.description, link: @gumtree_scrape.link, link_src: @gumtree_scrape.link_src, location: @gumtree_scrape.location, price: @gumtree_scrape.price, title: @gumtree_scrape.title, url: @gumtree_scrape.url, website: @gumtree_scrape.website } }
    end

    assert_redirected_to gumtree_scrape_url(GumtreeScrape.last)
  end

  test "should show gumtree_scrape" do
    get gumtree_scrape_url(@gumtree_scrape)
    assert_response :success
  end

  test "should get edit" do
    get edit_gumtree_scrape_url(@gumtree_scrape)
    assert_response :success
  end

  test "should update gumtree_scrape" do
    patch gumtree_scrape_url(@gumtree_scrape), params: { gumtree_scrape: { description: @gumtree_scrape.description, link: @gumtree_scrape.link, link_src: @gumtree_scrape.link_src, location: @gumtree_scrape.location, price: @gumtree_scrape.price, title: @gumtree_scrape.title, url: @gumtree_scrape.url, website: @gumtree_scrape.website } }
    assert_redirected_to gumtree_scrape_url(@gumtree_scrape)
  end

  test "should destroy gumtree_scrape" do
    assert_difference("GumtreeScrape.count", -1) do
      delete gumtree_scrape_url(@gumtree_scrape)
    end

    assert_redirected_to gumtree_scrapes_url
  end
end
