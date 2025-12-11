Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    namespace :v1 do
        post "auth/signUp", to: "auth#sign_up"
        post "auth/verifyEmail", to: "auth#verify_email"
        post "auth/login", to: "auth#login"
        get "auth/me", to: "auth#me"
        post "auth/forgetPassword", to: "auth#forget_password"
        put "auth/resetPassword", to: "auth#reset_password"
        resources :users, only: [] do
          resource :profile, only: [:show, :create, :update]
        end 


        resources :categories, only: :index
        resources :swaps do
          member do
            put "reject"
            put "accept"
          end
        end
        resources :items do
          collection do
            get "myItems", to: "items#my_items"
          end
          member do
            get "incomingRequests", to: "items#incoming_requests"
            get "outgoingRequests", to: "items#outgoing_requests"
          end
        end
    end
  end



  # Defines the root path route ("/")
  # root "posts#index"
end
