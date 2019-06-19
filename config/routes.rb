Rails.application.routes.draw do
  resources :users do
    resources :lists, shallow: true do
      resources :comments, shallow: true, except: [:show]
      resources :items, shallow: true, except: [:show] do
        match "/resolve", to: "items#resolve", via: [:put, :patch]
        match "/unsolve", to: "items#unsolve", via: [:put, :patch]
      end
    end
  end
  post "/auth/login", to: "authentication#login"
end
