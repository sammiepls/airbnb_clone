class ReservationsController < ApplicationController

  def create
    @reservation = Reservation.new(reservation_params)
      if @reservation.save
        flash.now[:success] = "You have successfully created a reservation"
        render template: "reservations/show"
      else
        flash.now[:failure] = "There was an error creating your reservation"
        render template: "reservations/new"
      end
  end

  private
  def reservation_params
    params.require(:listing).permit(:user_id,:listing_id,:guest_pax,:check_in,:check_out)
  end
end
