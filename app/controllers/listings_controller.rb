class ListingsController < ApplicationController
  before_action :require_login
  before_action :set_listing, only: [:show, :edit, :update, :destroy]

  def index
    @listings = Listing.search(params[:term])
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def edit
  end

  def create
    @listing = Listing.new(listing_params)
      if @listing.save
        flash[:success] = "You have successfully created a listing"
        render template: "listings/show"
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
  end


  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to @listing, notice: 'Listing was successfully updated.' }
        format.json { render :show, status: :ok, location: @listing }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  def user_listings
    @user = User.find(params[:id])
    @listings = Listing.where(user_id:params[:id])
  end

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def listing_params

      params.require(:listing).permit(:user_id,:name,:description,:address,:guest_pax,:bedroom_count,:bathroom_count,:price_per_night,:term)
    end
end
