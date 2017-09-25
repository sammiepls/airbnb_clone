class ReservationMailer < ApplicationMailer
  default from: "sammietests@gmail.com"

  def reservation_confirmation_email(customer,reservation)
    @reservation = reservation
    @customer = customer
    @url = user_reservation_url(customer, @reservation, host: 'https://tranquil-lake-88359.herokuapp.com')
    mail(to: @customer.email, subject: 'Your reservation is confirmed')
  end
end
