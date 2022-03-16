Rails.application.routes.draw do
  root "status#current"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do 
        resources :habits do
          get :today, on: :collection, to: "habits#show_today"
          resources :habit_logs
        end   
      end
      post "/auth/login", to: "authentication#login"
      get "/*a", to: "application#not_found"     
    end
    namespace :v2 do
      resources :users, only: [:create] do 
        resources :habit_plans do
          get :week, on: :collection, to: "habit_plans#show_week"
          get :today, on: :collection, to: "habit_plans#show_today"
          resources :habit_logs
        end
        resources :habits 
      end
      post "/auth/login", to: "authentication#login"
      get "/*a", to: "application#not_found"     
    end
  end
end
