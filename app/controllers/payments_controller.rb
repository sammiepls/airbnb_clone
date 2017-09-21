class PaymentsController < ApplicationController
  def new
    @client_token = Braintree::ClientToken.generate
  end

  def checkout
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]
     result = Braintree::Transaction.sale(
      :amount => "10.00", #this is currently hardcoded
      :payment_method_nonce => nonce_from_the_client,
      :options => {
         :submit_for_settlement => true
       }
      )

     if result.success?
       byebug
       flash[:success] = "Your transaction was successful!"
       redirect_to :root
     else
       flash[:failure] = "There was an error in your transaction. Please try again"
       redirect_to :root
     end
  end
end
