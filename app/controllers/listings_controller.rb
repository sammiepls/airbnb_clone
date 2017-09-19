class ListingsController < ApplicationController
  before_action :require_login
  before_action :set_listing, only: [:show, :edit, :update, :destroy]



  def index
    if params[:tag]
      @listings = Listing.tagged_with(params[:tag])
    elsif params[:term]
      @listings = Listing.search(params[:term])
    else
      @listings = Listing.paginate(:page => params[:page], :per_page => 18)
    end
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
        flash.now[:success] = "You have successfully created a listing"
        render template: "listings/show"
      else
        flash.now[:failure] = "There was an error creating your listing"
        render template: "listings/new"
      end
  end


  def update
      if @listing.update(listing_params)
        flash.now[:success] = "You have successfully created a listing"
        render template: "listings/show"
      else
        flash.now[:failure] = "There was an error updating your listing"
        render template: "listings/edit"
      end
  end

  def user_listings
    @user = User.find(params[:id])
    @listings = Listing.where(user_id:params[:id])
  end

  def destroy
    @listing.destroy
    flash.now[:success] = 'Listing was successfully destroyed'
    user_listings
    render template: "listings/index"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    def listing_params

      params.require(:listing).permit(:user_id,:name,:description,:address,:guest_pax,:bedroom_count,:bathroom_count,:price_per_night,:term,:tag_list)
    end
end
