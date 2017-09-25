class ReservationMailer < ApplicationMailer
  default from: "sammietests@gmail.com"

  def reservation_confirmation_email(customer,reservation)
    byebug
    @reservation = reservation
    @customer = customer
    @url = user_reservation_url(customer, @reservation, host: 'http://localhost:3000')
    mail(to: @customer.email, subject: 'Your reservation is confirmed')
  end
end
