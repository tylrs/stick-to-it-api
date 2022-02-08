Rails.application.routes.draw do
  root "application#hello"
  resources :users do 
    resources :habits do
      resources :habit_logs
    end
  end
  post "/auth/login", to: "authentication#login"
  get "/*a", to: "application#not_found"
end
