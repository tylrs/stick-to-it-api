Rails.application.routes.draw do
  root "status#current"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do 
        resources :habits, only: %i[index today create destroy] do
          get :today, on: :collection, to: "habits#show_today"
          resources :habit_logs, only: [:update]
        end   
      end
      post "/auth/login", to: "authentication#login"
      get "/*a", to: "application#not_found"     
    end
    namespace :v2 do
      resources :users, only: [:create] do 
        resources :habit_plans, only: %i[week today destroy] do
          get :week, on: :collection, to: "habit_plans#show_week"
          get :today, on: :collection, to: "habit_plans#show_today"
          post "invitation/create" 
          resources :habit_logs, only: [:update]
        end
        resources :habits, only: %i[create destroy]
      end
      get "/users/email", to: "users#show"
      post "/auth/login", to: "authentication#login"
      get "/*a", to: "application#not_found"     
    end
  end
end
