Rails.application.routes.draw do
  resources :users
  post "/auth/login", to: "authentication#login"
  resources :comments
  resources :items
  resources :lists
end
