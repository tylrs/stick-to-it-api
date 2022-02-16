Rails.application.routes.draw do
  root "status#current"

  resources :users do 
    resources :habits do
      get :today, on: :collection, to: "habits#show_today"
      resources :habit_logs
    end
  end

  post "/auth/login", to: "authentication#login"
  get "/*a", to: "application#not_found"
end
