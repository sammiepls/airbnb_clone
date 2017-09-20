class ListingsController < ApplicationController
  before_action :require_login
  before_action :set_listing, only: [:show, :edit, :update, :destroy, :verify]
  before_action :set_reservation, only: [:show,:update,:verify]

  def index
    if params[:tag]
      @listings = Listing.tagged_with(params[:tag]).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12)
    elsif params[:term]
      @listings = Listing.search(params[:term]).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12)
    elsif current_user.user?
      @listings = Listing.where(verification:true).order('updated_at DESC').paginate(:page => params[:page], :per_page => 12)
    else
      @listings = Listing.order('updated_at DESC').paginate(:page => params[:page], :per_page => 12)
    end
  end

  def show
  end

  def new
    @listing = Listing.new
  end

  def verify
    if allowed?(action: "verify", user: current_user)
      flash[:success] = "You have verified this listing."
      @listing.update(verification:true)
      render template: "/listings/show"
    else
      flash[:failure] = "Sorry. You are not allowed to perform this action."
      redirect_to :back
    end

  #   if current_user.user?
  #     flash[:failure] = "Sorry. You are not allowed to perform this action."
  #     redirect_to :back
  #  else
  #    @listing.update(verification:true)
  #    render template: "/listings/show"
  #  end
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
        flash.now[:success] = "You have successfully updated your listing"
        render template: "listings/show"
      else
        byebug
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
    flash[:success] = 'Listing was successfully destroyed'
    redirect_to listings_path
  end

  private
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # def set_listings
    #   @listings = Listing.all
    # end

    def set_reservation
      @reservation = Reservation.new
    end

    def listing_params
      params.require(:listing).permit(:user_id,:name,:description,:address,:guest_pax,:bedroom_count,:bathroom_count,:price_per_night,:term,:tag_list,photos: [])
    end
end
