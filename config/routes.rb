Rails.application.routes.draw do
  root "application#hello"
  get "/users/:user_id/habits/today", to: "habits#show_today"
  resources :users do 
    resources :habits do
      resources :habit_logs
    end
  end
  post "/auth/login", to: "authentication#login"
  get "/*a", to: "application#not_found"
end
