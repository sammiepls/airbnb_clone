class PaymentsController < ApplicationController
  def new
    @reservation = Reservation.find(params[:id])
    @client_token = Braintree::ClientToken.generate
  end

  def checkout
    total_price = params[:checkout_form][:amount]
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]
     result = Braintree::Transaction.sale(
      :amount => total_price,
      :payment_method_nonce => nonce_from_the_client,
      :options => {
         :submit_for_settlement => true
       }
      )

     if result.success?
       flash[:success] = "Your transaction was successful!"
       redirect_to :back
     else
       flash[:failure] = "There was an error in your transaction. Please try again"
       redirect_to :back
     end
  end
end
