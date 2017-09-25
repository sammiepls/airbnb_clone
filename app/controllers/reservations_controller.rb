class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:show, :update, :destroy]

  def index
    @reservations = Reservation.where(user_id:params[:user_id]).order('updated_at DESC')
  end

  def create
    @reservation = Reservation.new(reservation_params)
      if @reservation.save
        flash.now[:success] = "You have successfully created a reservation"
        render template: "reservations/show"
      else
        flash.now[:failure] = "There was an error creating your reservation"
        @listing = Listing.find(params[:reservation][:listing_id])
        render template: "listings/show"
      end
  end

  def show
  end

  def update
  end

  def destroy
    @reservation.destroy
    flash[:success] = 'Reservation was successfully deleted'
    redirect_to user_reservations_path
  end

  private
  def reservation_params
    params.require(:reservation).permit(:user_id,:listing_id,:guest_pax,:check_in,:check_out,:paid)
  end

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end
end
