Rails.application.routes.draw do
  root "status#current"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do 
        resources :habits, only: [:index, :today, :create, :destroy] do
          get :today, on: :collection, to: "habits#show_today"
          resources :habit_logs, only: [:update]
        end   
      end
      post "/auth/login", to: "authentication#login"
      get "/*a", to: "application#not_found"     
    end
    namespace :v2 do
      resources :users, only: [:create] do 
        resources :habit_plans, only: [:week, :today] do
          get :week, on: :collection, to: "habit_plans#show_week"
          get :today, on: :collection, to: "habit_plans#show_today"
          resources :habit_logs, only: [:update]
        end
        resources :habits, only: [:create, :destroy] 
      end
      post "/auth/login", to: "authentication#login"
      get "/*a", to: "application#not_found"     
    end
  end
end
