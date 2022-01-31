Rails.application.routes.draw do
  root "application#hello"
  resources :users do 
    resources :habits
  end
  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
