Rails.application.routes.draw do
  root "listings#index"

  # Payments
  get '/reservations/:id/payment' => "payments#new", as: "payment_new"
  post '/payments/checkout'

  get 'tags/:tag', to: 'listings#index', as: :tag
  resources :listings
  get "/users/:id/listings" => "listings#user_listings", as: "user_listings"
  post "/listings/:id" =>"listings#verify", as: "verify_listing"

  resources :users
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
    resources :reservations, except: [:new]
  end

  get "/sign_in" => "sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Facebook authentication
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"



end
