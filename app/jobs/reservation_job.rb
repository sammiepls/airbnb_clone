class ReservationJob < ApplicationJob
  queue_as :default

  def perform(current_user, reservation)
      ReservationMailer.reservation_confirmation_email(current_user, reservation).deliver_later
  end
end
