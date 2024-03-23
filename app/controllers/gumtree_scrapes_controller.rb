class GumtreeScrapesController < ApplicationController
  before_action :set_gumtree_scrape, only: %i[ show edit update destroy ]

  # GET /gumtree_scrapes or /gumtree_scrapes.json
  def index
    @gumtree_scrapes = GumtreeScrape.all
  end

  # GET /gumtree_scrapes/1 or /gumtree_scrapes/1.json
  def show
  end

  # GET /gumtree_scrapes/new
  def new
    @gumtree_scrape = GumtreeScrape.new
  end

  # GET /gumtree_scrapes/1/edit
  def edit
  end

  # POST /gumtree_scrapes or /gumtree_scrapes.json
  def create
    @gumtree_scrape = GumtreeScrape.new(gumtree_scrape_params)

    respond_to do |format|
      if @gumtree_scrape.save
        format.html { redirect_to gumtree_scrape_url(@gumtree_scrape), notice: "Gumtree scrape was successfully created." }
        format.json { render :show, status: :created, location: @gumtree_scrape }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gumtree_scrape.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gumtree_scrapes/1 or /gumtree_scrapes/1.json
  def update
    respond_to do |format|
      if @gumtree_scrape.update(gumtree_scrape_params)
        format.html { redirect_to gumtree_scrape_url(@gumtree_scrape), notice: "Gumtree scrape was successfully updated." }
        format.json { render :show, status: :ok, location: @gumtree_scrape }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gumtree_scrape.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gumtree_scrapes/1 or /gumtree_scrapes/1.json
  def destroy
    @gumtree_scrape.destroy!

    respond_to do |format|
      format.html { redirect_to gumtree_scrapes_url, notice: "Gumtree scrape was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gumtree_scrape
      @gumtree_scrape = GumtreeScrape.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gumtree_scrape_params
      params.require(:gumtree_scrape).permit(:url, :title, :description, :link, :link_src, :price, :location, :website)
    end
end
